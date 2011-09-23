Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33301 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab1IWVLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 17:11:19 -0400
Received: by fxe4 with SMTP id 4so4211625fxe.19
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 14:11:18 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Oliver Freyermuth <o.freyermuth@googlemail.com>
Subject: Re: [PATCH] Add support for PCTV452E.
Date: Sat, 24 Sep 2011 00:11:21 +0300
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Doychin Dokov <root@net1.cc>,
	Steffen Barszus <steffenbpunkt@googlemail.com>,
	Dominik Kuhlen <dkuhlen@gmx.net>,
	Andre Weidemann <Andre.Weidemann@web.de>,
	"Michael H. Schimek" <mschimek@gmx.at>
References: <201105242151.22826.hselasky@c2i.net> <4E7CE5F8.1050900@redhat.com> <4E7CF2E7.8090100@googlemail.com>
In-Reply-To: <4E7CF2E7.8090100@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109240011.21970.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

В сообщении от 23 сентября 2011 23:58:15 автор Oliver Freyermuth написал:
> Thanks for the review!
> 
> As this is the first time I touched module- / kernel-code and I am not
> really familiar with the structures of the rc-system, I do not really
> feel up to porting to non-legacy rc-support (Igors version also appears
> to use rc-legacy), and up to now, it was only combining patches and
> fixing small glitches for me.
> However, feel free to use me as a tester (I have the hardware available,
> after all) or flood me with links to guidelines or further instructions.
> 
> Thanks again,
>      Oliver Freyermuth
>

Note, this patch is good for testing with media_build system. Just in case 
someone want not to load ~500 Mb kernel git tree, then configure, compile, 
install vmlinuz and so on, so on.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
