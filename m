Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36274 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbcD0RMP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 13:12:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id w143so15072402wmw.3
        for <linux-media@vger.kernel.org>; Wed, 27 Apr 2016 10:12:14 -0700 (PDT)
From: =?UTF-8?Q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE_?=
	 =?UTF-8?Q?=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?=
	<ivo.g.dimitrov.75@gmail.com>
Reply-To: =?UTF-8?Q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE_?=
	   =?UTF-8?Q?=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?=
	  <ivo.g.dimitrov.75@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: pavel@ucw.cz, sakari.ailus@iki.fi, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
	 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
	 <20160427030850.GA17034@earth> <572048AC.7050700@gmail.com>
	 <572062EF.7060502@gmail.com> <20160427164256.GA8156@earth>
In-Reply-To: <20160427164256.GA8156@earth>
Content-Type: text/plain; charset=utf-8
Content-ID: <1461777169.18568.1.camel@Nokia-N900>
Date: Wed, 27 Apr 2016 20:12:50 +0300
Message-Id: <1461777170.18568.2.camel@Nokia-N900>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed Apr 27 19:42:56 2016 Sebastian Reichel <sre@kernel.org> wrote:
> Hi,
> 
> On Wed, Apr 27, 2016 at 09:57:51AM +0300, Ivaylo Dimitrov wrote:
> > > > https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/log/?h=n900-camera-ivo
> > > 
> > > Ok, going to diff with my tree to see what I have missed to send in
> > > the patchset
> > 
> > Now, that's getting weird.
> 
> [...]
> The zImage + initrd works with the steps you described below. I

Great!

> received a completly black image, but at least there are interrupts
> and yavta is happy (=> it does not hang).
>

The black image is because by default exposure and gain are set to 0 :). 
Use yavta to set the appropriate controls. You can
also enable test patterns from there.

> 
> Can you try if your config still works if you configure
> CONFIG_VIDEO_OMAP3=y, but leaving the sensors configured
> as modules? I will try the reverse process (using my config
> and moving config options to =m).
>

Will try to find time later today.
 
> > ~$ modprobe smiapp
> 
> modprobing smiapp resulted in a kernel message about a missing
> symbol btw. I currently don't remember which one and it's no
> longer in dmesg due to ISP debug messages.
>

Never seen such missing symbols.

> > Please, Sebastian and Pavel, make sure you're not using some
> > development devices, old board versions need VAUX3 enabled as well,
> > and this is not supported in the $subject patchset. I guess you may
> > try to make VAUX3 always-on in board DTS if that's the case, but I've
> > never tested that, my device is a production one.
> 
> I don't have pre-production N900s. The phone I use for development
> is HW revision 2101 with Finish keyboard layout. Apart from that
> I have my productive phone, which is rev 2204 with German layout.
> 

The one I use for testing is 2204, but I guess it is
irrelevant now you have it finally working.

Ivo
