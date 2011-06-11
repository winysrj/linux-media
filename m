Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:25004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757665Ab1FKNsI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 09:48:08 -0400
Message-ID: <4DF37214.4040103@redhat.com>
Date: Sat, 11 Jun 2011 10:48:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 6/7] tuner-core: fix g_tuner
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl> <54ea5935863e922ac5b9e5faf61d9b69e4f31492.1307798213.git.hans.verkuil@cisco.com>
In-Reply-To: <54ea5935863e922ac5b9e5faf61d9b69e4f31492.1307798213.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 11-06-2011 10:34, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> g_tuner just returns the tuner data for the current tuner mode and the
> application does not have to set the tuner type. So don't test for a
> valid tuner type.

This also breaks support for a separate radio tuner, as both TV and radio
tuners will touch at the g_tuner struct.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/tuner-core.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
> index 8ef7790..7280998 100644
> --- a/drivers/media/video/tuner-core.c
> +++ b/drivers/media/video/tuner-core.c
> @@ -1120,8 +1120,6 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
>  	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
>  
> -	if (!supported_mode(t, vt->type))
> -		return 0;
>  	vt->type = t->mode;
>  	if (analog_ops->get_afc)
>  		vt->afc = analog_ops->get_afc(&t->fe);

