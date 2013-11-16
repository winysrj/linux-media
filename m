Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm5-vm5.access.bullet.mail.bf1.yahoo.com ([216.109.114.132]:43682
	"EHLO nm5-vm5.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743Ab3KPXZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Nov 2013 18:25:22 -0500
From: "Tim E. Real" <termtech@rogers.com>
To: linux-media@vger.kernel.org
Subject: SAA7134 driver reports zero frame rate
Date: Sat, 16 Nov 2013 18:19:32 -0500
Message-ID: <1802041.4NDiOr0LmV@col-desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SAA7134 driver causes libav to crash because the
 driver reports zero frame rate.
Thus it is virtually impossible to do any recording.

About a year ago I debugged and found I had to do this,
 (but it was not enough, more fixes would be needed):

In libav/libavdevice/v4l2.c :

static int v4l2_set_parameters(AVFormatContext *s1, AVFormatParameters *ap)
{
...
    s1->streams[0]->codec->time_base.den = tpf->denominator;
    s1->streams[0]->codec->time_base.num = tpf->numerator;

    // By Tim. BUG: The saa7134 driver (at least) reports zero framerate, 
    //  causing abort in rescale. So just force it.
    if(s1->streams[0]->codec->time_base.den == 0 || 
        s1->streams[0]->codec->time_base.num == 0)
    {
      s1->streams[0]->codec->time_base.num = 1;
      s1->streams[0]->codec->time_base.den = 30;
    }
      
    s->timeout = 100 +
        av_rescale_q(1, s1->streams[0]->codec->time_base,
                        (AVRational){1, 1000});

    return 0;
}

I looked at the SAA7134 module parameters but couldn't seem to
 find anything to help. 

Does anyone know how to make the module work so it sets a proper 
 frame rate, or if this problem been fixed recently?

Thanks for your help.
Tim.

