Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:51096 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZCIG5z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 02:57:55 -0400
Date: Mon, 9 Mar 2009 07:52:50 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: "Andreas Kurz" <kurz.andi@gmx.at>
Cc: linux-media@vger.kernel.org
Subject: Re: TT 3650
Message-ID: <20090309075250.4acf4fec@free.fr>
In-Reply-To: <20090308152702.258090@gmx.net>
References: <20090218092217.232120@gmx.net>
	<20090218103353.64bf6400@free.fr>
	<20090223113439.90620@gmx.net>
	<20090223131909.126d0d8c@free.fr>
	<20090308152702.258090@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 08 Mar 2009 16:27:02 +0100
"Andreas Kurz" <kurz.andi@gmx.at> wrote:

> Hi...

Hi Andreas,

> Still having some problems getting this card to work for me (Suse
> 11.1, KDE 4.1). I have successfully installed the suggested
> non-main-repo, szap-s2 and dvbstream. Unter Yast/TV-card I used the
> Experts button to tell the system to use a unknown tv-card with v4l2.
> Unfotunately dvbstream -o 8192 | vlc leaves me with 
> 
> scyth@NotebookMMC:~> dvbstream -o 8192 | vlc  
	[snip]

You forgot to tell vlc which is the source:

	dvbstream -o 8192 | vlc -
	                       ~~~

Don't forget to run szap-s2 with this command. Otherwise, you must give
dvbstream the frequency and the symbol rate of the transponder.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
