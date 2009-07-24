Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:54878 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZGXQGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 12:06:17 -0400
Received: by ewy26 with SMTP id 26so1854308ewy.37
        for <linux-media@vger.kernel.org>; Fri, 24 Jul 2009 09:06:16 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mark Zimmerman <markzimm@frii.com>
Subject: Re: TBS 8920 still fails to initialize - cx24116_readreg error
Date: Fri, 24 Jul 2009 19:06:11 +0300
Cc: linux-media@vger.kernel.org
References: <20090724023315.GA96337@io.frii.com>
In-Reply-To: <20090724023315.GA96337@io.frii.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907241906.11914.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24 июля 2009 05:33:15 Mark Zimmerman wrote:
> Greetings:
>
> Using current current v4l-dvb drivers, I get the following in the
> dmesg:
>
> cx88[1]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72]
> cx88[1]/2: cx2388x based DVB/ATSC card
> cx8802_alloc_frontends() allocating 1 frontend(s)
> cx24116_readreg: reg=0xff (error=-6)
> cx24116_readreg: reg=0xfe (error=-6)
> Invalid probe, probably not a CX24116 device
> cx88[1]/2: frontend initialization failed
> cx88[1]/2: dvb_register failed (err = -22)
> cx88[1]/2: cx8802 probe failed, err = -22
>
> Does this mean that one of the chips on this card is different than
> expected? How can I gather useful information about this?
>
> -- Mark
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi
You can try:
http://www.tbsdtv.com/download/tbs6920_8920_v23_linux_x86_x64.rar

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
