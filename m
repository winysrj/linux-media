Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:48218 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbZBWMZZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 07:25:25 -0500
Date: Mon, 23 Feb 2009 13:19:09 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: "Andreas Kurz" <kurz.andi@gmx.at>
Cc: linux-media@vger.kernel.org
Subject: Re: TT 3650
Message-ID: <20090223131909.126d0d8c@free.fr>
In-Reply-To: <20090223113439.90620@gmx.net>
References: <20090218092217.232120@gmx.net>
	<20090218103353.64bf6400@free.fr>
	<20090223113439.90620@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Feb 2009 12:34:39 +0100
"Andreas Kurz" <kurz.andi@gmx.at> wrote:

> Concerning this card (TT 3650 CI) in combination with the
> non-repo-driver (suggested below): which tuner should I use? Is there
> a special one needed?

Hi Andreas,

By tuner, do you mean the program to watch TV?

I use 'vlc' with a playing list for DVB-S. For DVB-S2, I must use
'szap-s2' to select the transponder and 'dvbstream' + 'vlc':
	dvbstream -o 8192 | vlc -

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
