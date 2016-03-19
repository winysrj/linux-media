Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54822 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbcCSKjx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2016 06:39:53 -0400
Date: Sat, 19 Mar 2016 07:39:44 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, perex@perex.cz, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound/usb: fix to release stream resources from
 media_snd_device_delete()
Message-ID: <20160319073944.60235d88@recife.lan>
In-Reply-To: <20160318235708.1eccf0e6@recife.lan>
References: <1458355831-9467-1-git-send-email-shuahkh@osg.samsung.com>
	<20160318235708.1eccf0e6@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Mar 2016 23:57:08 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Fri, 18 Mar 2016 20:50:31 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
> > Fix to release stream resources from media_snd_device_delete() before
> > media device is unregistered. Without this change, stream resource free
> > is attempted after the media device is unregistered which would result
> > in use-after-free errors.
> > 
> > Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> > ---
> > 
> > - Ran bind/unbind loop (1000 iteration) test on snd-usb-audio
> >   while running mc_nextgen_test loop (1000 iterations) in parallel.
> > - Ran bind/unbind and rmmod/modprobe tests on both drivers. Also
> >   generated graphs when after bind/unbind, rmmod/modprobe. Graphs
> >   look good.
> > - Note: Please apply the following patch to fix memory leak:
> >   sound/usb: Fix memory leak in media_snd_stream_delete() during unbind
> >   https://lkml.org/lkml/2016/3/16/1050
> > 
> >  sound/usb/media.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/sound/usb/media.c b/sound/usb/media.c
> > index de4a815..e35af88 100644
> > --- a/sound/usb/media.c
> > +++ b/sound/usb/media.c
> > @@ -301,6 +301,13 @@ int media_snd_device_create(struct snd_usb_audio *chip,
> >  void media_snd_device_delete(struct snd_usb_audio *chip)
> >  {
> >  	struct media_device *mdev = chip->media_dev;
> > +	struct snd_usb_stream *stream;
> > +
> > +	/* release resources */
> > +	list_for_each_entry(stream, &chip->pcm_list, list) {
> > +		media_snd_stream_delete(&stream->substream[0]);
> > +		media_snd_stream_delete(&stream->substream[1]);  
> 
> I'll look on it better tomorrow, but it sounds weird to hardcode
> substream[0] and [1] here... are you sure that this is valid for
> *all* devices supported by snd-usb-audio?

After looking at pcm.c and finding this:

static void snd_usb_audio_stream_free(struct snd_usb_stream *stream)
{
	free_substream(&stream->substream[0]);
	free_substream(&stream->substream[1]);
	list_del(&stream->list);
	kfree(stream);
}

It seems that assuming that substream is always an array with size 2
is right.

I'll do some tests with it today with your patch.

Regards,
Mauro

> 
> Regards,
> Mauro
> 
> > +	}
> >  
> >  	media_snd_mixer_delete(chip);
> >    
> 
> 


-- 
Thanks,
Mauro
