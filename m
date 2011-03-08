Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56337 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1CHH6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 02:58:40 -0500
Received: by fxm17 with SMTP id 17so4869433fxm.19
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2011 23:58:39 -0800 (PST)
Date: Tue, 8 Mar 2011 08:51:07 +0100
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Scott <igetmyemailhere@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Compiling v4l fatal error: linux/ti_wilink_st.h: No such file
 or directory
Message-ID: <20110308085107.7bcb52ef@grobi>
In-Reply-To: <FBB75E3F-418B-470F-8169-25CC3AFBA73F@gmail.com>
References: <AANLkTikJPTMGirPOVmcH-Wit-0B8BC8cqEbCMj=nLc+b@mail.gmail.com>
	<864FEDC7-B235-4878-AE6B-77E2A62D1ED9@wilsonet.com>
	<FBB75E3F-418B-470F-8169-25CC3AFBA73F@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 7 Mar 2011 17:22:39 -0600
Scott <igetmyemailhere@gmail.com> wrote:

> 
>   Same problem.  I purged both  linux-headers-2.6.35-27-generic,
> linux-source-2.6.35, then reinstalled them, and did an apt-get
> update/upgrade.  I then deleted media_build and ran...

linux-headers should be enough, no need for linux-source, and you need
never both IMHO.

> git clone git://linuxtv.org/media_build.git
> cd media_build
> ./build.sh
> Compile breaks
> vi vrl/.config changed CONFIG_DVB_FIREDTV=m to =n

should not be necessary anymore, at least its not needed here. 

> ./build.sh

You might want to try my dkms package - not sure if it works on
maverick (its build on/for lucid) - but in theory it should (except
if the number of modules differs for different kernel). 
If not you get atleast the latest source which compiles fine here. 

https://launchpad.net/~yavdr/+archive/testing-vdr/+packages?field.name_filter=v4l-dvb-dkms&field.status_filter=published&field.series_filter=

Just uploaded new version with media_build and media_tree as of now. 

Let me know if it works.

Steffen
