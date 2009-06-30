Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:20159 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZF3T4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 15:56:14 -0400
Received: by qw-out-2122.google.com with SMTP id 9so185817qwb.37
        for <linux-media@vger.kernel.org>; Tue, 30 Jun 2009 12:56:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906301548.02518.gczerw@comcast.net>
References: <200906301301.04604.gczerw@comcast.net>
	 <4A4A64F9.6070807@linuxtv.org>
	 <829197380906301227q52e7b215p359adaa3206dba79@mail.gmail.com>
	 <200906301548.02518.gczerw@comcast.net>
Date: Tue, 30 Jun 2009 15:56:08 -0400
Message-ID: <829197380906301256w2f0a701ak2332d9ec2cfae35e@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge HVR-1800 not working at all
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: gczerw@comcast.net
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 30, 2009 at 3:48 PM, George Czerw<gczerw@comcast.net> wrote:
> Devin, thanks for the reply.
>
> Lsmod showed that "tuner" was NOT loaded (wonder why?), a "modprobe tuner"
> took care of that and now the HVR-1800 is displaying video perfectly and the
> tuning function works.  I guess that I'll have to add "tuner" into
> modprobe.preload.d????  Now if only I can get the sound functioning along with
> the video!
>
> George

Admittedly, I don't know why you would have to load the tuner module
manually on the HVR-1800.  I haven't had to do this on other products?

If you are doing raw video capture, then you need to manually tell
applications where to find the ALSA device that provides the audio.
If you're capturing via the MPEG encoder, then the audio will be
embedded in the stream.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
