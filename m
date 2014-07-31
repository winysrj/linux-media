Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.inunum.li ([83.169.19.93]:48386 "EHLO
	lvps83-169-19-93.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbaGaPsz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 11:48:55 -0400
Message-ID: <53DA656C.5020009@InUnum.com>
Date: Thu, 31 Jul 2014 17:49:00 +0200
From: Michael Dietschi <michael.dietschi@InUnum.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.sourceforge.net>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp with DM3730 not working?!
References: <53D12786.5050906@InUnum.com>	<1915586.ZFV4ecW0Zg@avalon>	<CA+2YH7vhYuvUbFHyyr699zUdJuYWDtzweOGo0hGDHzT-+oFGjw@mail.gmail.com>	<2300187.SbcZEE0rv0@avalon>	<53D90786.9090809@InUnum.com>	<CA+2YH7vrD_N32KsksU2G37BhLPBMHJDbizrVb_N+=mnHC3oNmQ@mail.gmail.com>	<53DA1538.90709@InUnum.com>	<CA+2YH7sROaGEtVLBs9N7FdWG5mzPZDtGgOaD2sgea--kqLELQA@mail.gmail.com>	<53DA371F.9070907@InUnum.com> <CA+2YH7tpTs_snyqZQQGXCg8b5mAYejyRceJy5QzuaEV2sgD-cQ@mail.gmail.com>
In-Reply-To: <CA+2YH7tpTs_snyqZQQGXCg8b5mAYejyRceJy5QzuaEV2sgD-cQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 31.07.2014 15:15, schrieb Enrico:
> It seems you are missing this: media-ctl --set-format '"OMAP3 ISP 
> CCDC":1 [UYVY 720x480 field:interlaced-tb]' and add --field 
> interlaced-tb to yavta. Enrico 

Yippieh! It seems to work now - At least I am getting an file... If it 
is a "nice image" will be determined tomorrow!

Thank you for the help,
Michael

