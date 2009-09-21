Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54578 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZIUWPH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 18:15:07 -0400
Received: by fxm18 with SMTP id 18so397287fxm.17
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 15:15:08 -0700 (PDT)
Date: Tue, 22 Sep 2009 00:15:05 +0200
From: Uros Vampl <mobile.leecher@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
Message-ID: <20090921221505.GA5187@zverina>
References: <20090913193118.GA12659@zverina>
 <20090921204418.GA19119@zverina>
 <829197380909211349r68b92b3em577c02d0dee9e4fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <829197380909211349r68b92b3em577c02d0dee9e4fc@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21.09.09 16:49, Devin Heitmueller wrote:
> On Mon, Sep 21, 2009 at 4:44 PM, Uros Vampl <mobile.leecher@gmail.com> wrote:
> > Hello.
> >
> > Partial success. With the attached patch, DVB works. But I have no idea
> > how to get analog audio working correctly. Any help would be
> > appreciated.
> >
> > Regards,
> > Uroš
> 
> Hello Uroš,
> 
> Sorry I somehow missed your previous email.  I have a patch already
> which should make the device work correctly, and am issuing a PULL
> request for it this week.
> 
> Regarding the analog audio, I'm not sure how you are testing, but if
> you are using tvtime, it is known that tvtime does not support analog
> audio for raw devices such as this.  You need to run arecord/aplay in
> a separate window.
> 
> Devin

Hi,

I tried arecord/aplay and sox with tvtime, and also mplayer (which 
has 
built-in audio support). I know about these tricks, I've used them 
successfully with Markus' em28xx-new driver. But with v4l-dvb it's as I 
said, audio is there but it's extremely quiet. If you have suggestions 
how I should try to diagnoze this, I'm all ears.

Regards,
Uroš 
