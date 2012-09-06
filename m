Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:30760 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2IFMmq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 08:42:46 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id q86Cgig8000571
	for <linux-media@vger.kernel.org>; Thu, 6 Sep 2012 12:42:44 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Question: em28xx and audio inputs?
Date: Thu, 6 Sep 2012 14:42:40 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209061442.40850.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've started work on fixing v4l2-compliance failures in em28xx and I came
across a broken ENUM/G/S_AUDIO implementation.

This is the current implementation:

static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
{
        struct em28xx_fh   *fh    = priv;
        struct em28xx      *dev   = fh->dev;

        if (!dev->audio_mode.has_audio)
                return -EINVAL;

        switch (a->index) {
        case EM28XX_AMUX_VIDEO:
                strcpy(a->name, "Television");
                break;
        case EM28XX_AMUX_LINE_IN:
                strcpy(a->name, "Line In");
                break;
        case EM28XX_AMUX_VIDEO2:
                strcpy(a->name, "Television alt");
                break;
        case EM28XX_AMUX_PHONE:
                strcpy(a->name, "Phone");
                break;
        case EM28XX_AMUX_MIC:
                strcpy(a->name, "Mic");
                break;
        case EM28XX_AMUX_CD:
                strcpy(a->name, "CD");
                break;
        case EM28XX_AMUX_AUX:
                strcpy(a->name, "Aux");
                break;
        case EM28XX_AMUX_PCM_OUT:
                strcpy(a->name, "PCM");
                break;
        default:
                return -EINVAL;
        }

        a->index = dev->ctl_ainput;
        a->capability = V4L2_AUDCAP_STEREO;

        return 0;
}

static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
{
        struct em28xx_fh   *fh  = priv;
        struct em28xx      *dev = fh->dev;


        if (!dev->audio_mode.has_audio)
                return -EINVAL;

        if (a->index >= MAX_EM28XX_INPUT)
                return -EINVAL;
        if (0 == INPUT(a->index)->type)
                return -EINVAL;

        dev->ctl_ainput = INPUT(a->index)->amux;
        dev->ctl_aoutput = INPUT(a->index)->aout;

        if (!dev->ctl_aoutput)
                dev->ctl_aoutput = EM28XX_AOUT_MASTER;

        return 0;
}

The g_audio implementation is wrong because it has a switch on a->index instead
of on dev->ctl_ainput. That's easy enough to fix, but s_audio is a real problem:
it interprets a->index as an input index instead of as an audio input index.

In addition, ctl_ainput does not have to be an EM28XX_AMUX_* index, as some
boards use an msp34xx instead.

I see a number of possible solutions:

1) Just delete the audio input support. Clearly nobody has used this code.
2) Don't implement audio input support if the msp3400 is used, otherwise
allow the user to set the em28xx AMUX to any of the possible values.
3) Don't implement audio input support if the msp3400 is used, otherwise
allow the user to set the em28xx AMUX to any of the values supported by
the list of inputs for that board.

The difference between 2 and 3 is that with 2 you can select e.g. a CD
input, even though it is unlikely that it is hooked up to something.

I have no idea whether that would make sense or not. I'm inclined to do
either 1 or 3.

Any em28xx that can shed some light on this?

Regards,

	Hans
