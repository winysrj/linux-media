Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:51415 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbZDLRRy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2009 13:17:54 -0400
Date: Sun, 12 Apr 2009 19:08:31 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: ErV2005@rambler.ru
Cc: linux-media@vger.kernel.org
Subject: Re: Dark picture on Genius E-Messenger 112 webcam with yesterday's
 v4l-dvb code.
Message-ID: <20090412190831.0350590f@free.fr>
In-Reply-To: <200904111816.14704.ErV2005@rambler.ru>
References: <200904111816.14704.ErV2005@rambler.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 11 Apr 2009 18:16:14 +0400
Victor <ErV2005@rambler.ru> wrote:

> Hello.

Hello Victor,

> I'm using Genius E-Messenger 112 webcam on Slackware 12.2 with
> 2.6.27.7 kernel (custom-built) and yesterday's v4l-dvb sources
> checked out via "mercurial" ("hg log" returns "11445:dba0b6fae413" as
> latest commit). the camera uses gspca_main and gspca_pac207 kernel
> modules.`
> 
> Camera works (with LD_PRELOAD=v4l2convert.so) in mplayer (mplayer
> tv://) and skype, but picture is way too dark. It looks like
> "contrast" is permanently set at maximum, and doesn't change
> (although it looks like camera tries to adjust brightness
> automatically).
> 
> How can this be fixed?

Did you try to change the webcam controls? (there are brightness,
exposure, autogain and gain - they may be changed by programs as
v4l2ucp or vlc)

> Few articles in the web talk about
> "/sys/module/gspca/parameters/gamma", etc, but it looks like such
> advice is outdated. I assume this device is not completely supported
> (people on the web recommend to avoid using this camera on linux), so
> perhaps I could provide additional data to make it work in the
> future. Or, perhaps, someone could tell me where (in gspca source) I
> could start trying to fix that problem.

You may ask to Hans de Goede who is the maintainer of the pac207
driver.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
