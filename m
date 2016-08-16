Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:38574 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbcHPHPN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 03:15:13 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de>
Date: Tue, 16 Aug 2016 09:10:35 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <17EDB327-2244-42A4-A052-645D82CA94A4@darmarit.de>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de> <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 10.08.2016 um 11:52 schrieb Markus Heiser <markus.heiser@darmarIT.de>:

> The vdr format was broken, I got '(null)' entries
> 
> HD:11494:S1HC23I0M5N1O35:S:(null):22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0:
> 0-:1----:2--------------:3:4-----:
> 
> refering to the VDR Wikis ...
> 
> * LinuxTV: http://www.linuxtv.org/vdrwiki/index.php/Syntax_of_channels.conf
> * german comunity Wiki: http://www.vdr-wiki.de/wiki/index.php/Channels.conf#Parameter_ab_VDR-1.7.4
> 
> There is no field at position 4 / in between "Source" and "SRate" which
> might have a value. I suppose the '(null):' is the result of pointing
> to *nothing*.
> 
> An other mistake is the ending colon (":") at the line. It is not
> explicit specified but adding an collon to the end of an channel entry
> will prevent players (like mpv or mplayer) from parsing the line (they
> will ignore these lines).
> 
> At least: generating a channel list with
> 
>  dvbv5-scan --output-format=vdr ...
> 
> will result in the same defective channel entry, containing "(null):"
> and the leading collon ":".
> 

Hi,

please apply this patch or give me at least some feedback / thanks.

-- Markus 