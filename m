Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64352 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab2HCSmY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 14:42:24 -0400
Received: by ghrr11 with SMTP id r11so1199310ghr.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 11:42:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyaO5xhjUCVW5QfeLDoh=a6WE73aiAOXX5ZkOiM=efOfQ@mail.gmail.com>
References: <1344016352-20302-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+UdxdawZMeniA-tia3qKARbX_+u2k8PnbhA_FhDKUMv3Q@mail.gmail.com>
	<CAGoCfiyaO5xhjUCVW5QfeLDoh=a6WE73aiAOXX5ZkOiM=efOfQ@mail.gmail.com>
Date: Fri, 3 Aug 2012 15:42:23 -0300
Message-ID: <CALF0-+Vhng3=GUJs5k9fiktkE6mEtDNEzKfP8+zjTSmCCRez8w@mail.gmail.com>
Subject: Re: [PATCH] em28xx: Fix height setting on non-progressive captures
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

Thanks for answering.

On Fri, Aug 3, 2012 at 3:26 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Fri, Aug 3, 2012 at 2:11 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> On Fri, Aug 3, 2012 at 2:52 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>>> This was introduced on commit c2a6b54a9:
>>> "em28xx: fix: don't do image interlacing on webcams"
>>> It is a known bug that has already been reported several times
>>> and confirmed by Mauro.
>>> Tested by compilation only.
>>>
>>
>> I wonder if it's possible to get an Ack or a Tested-By from any of the
>> em28xx owners?
>
> This shouldn't be accepted upstream without testing at least on x86.
> I did make such a change to make it work in my ARM tree, but I don't
> fully understand the nature of the change and I'm not completely
> confident it's correct for x86 (based on my reading of the datasheet
> and how the accumulator field is structured in the em28xx chip).
> Also, I actually don't have any progressive devices (I've got probably
> a dozen em28xx devices, but they are all interlaced capture), which
> made me particularly hesitant to submit this patch.
>

Wait a minute, unless I completely misunderstood the bug (which is possible),
I think this patch is straightforward.

By the look of this hunk on commit c2a6b54a:

---------------------------------8<--------------------------
diff --git a/drivers/media/video/em28xx/em28xx-core.c
b/drivers/media/video/em28xx/em28xx-core.c
index 5b78e19..339fffd 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -720,7 +720,10 @@ int em28xx_resolution_set(struct em28xx *dev)
 {
        int width, height;
        width = norm_maxw(dev);
-       height = norm_maxh(dev) >> 1;
+       height = norm_maxh(dev);
+
+       if (!dev->progressive)
+               height >>= norm_maxh(dev);

--------------------------------->8--------------------------

It seems to me that for non-progressive the height should just be

  height = height / 2 (or height = height >> 1)

as was before, and as my patch is doing. It seems to driver will
"merge" the interlaced
frames and so the "expected" height is half the real height.
I hope I got it right.

That said and no matter how straightforward may be, which I'm not sure,
I also want the patch to get tested before being accepted.



>> Also, Devin: you mentioned in an old mail [1] you had some patches for em28xx,
>> but you had no time to put them into shape for submission.
>>
>> If you want to, send then to me (or the full em28xx tree) and I can
>> try to submit
>> the patches.
>
> Yeah, probably not a bad idea.  I've been sitting on the tree because
> they haven't been tested on any other platforms and some of them are
> not necessarily generally suitable for the mainline kernel.  And of
> course the tree needs to be parsed out into an actual patch series,
> and each patch has to be individually validated across multiple
> devices to ensure they don't cause breakage (they were tested on an
> em2863, but I have no idea if they cause problems on other chips such
> as the em2820 or em2880).
>
> All that said, I'm not really sure what the benefit would be in
> sending you the tree if you don't actually have any hardware to test
> with.  The last thing we need is more crap being sent upstream that is
> "compile tested only" since that's where many of the regressions come
> from (well meaning people sending completely untested 'cleanup
> patches' can cause more harm than good).
>

Mmm, you're right. I was rather thinking in patches that fixes "obvious"
(whatever that may be) things and assuming these patches could get some
community testing.

So: never mind, bad idea. I've sent enough zero-test patches, which
only means more work for Mauro :-(

Thanks,
Ezequiel.
