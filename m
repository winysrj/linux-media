Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx27.mail.ru ([94.100.176.41]:51663 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbZBQTzf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 14:55:35 -0500
Received: from [95.53.180.84] (port=25966 helo=localhost.localdomain)
	by mx27.mail.ru with asmtp
	id 1LZW2W-0005VC-00
	for linux-media@vger.kernel.org; Tue, 17 Feb 2009 22:55:32 +0300
Date: Tue, 17 Feb 2009 23:06:40 +0300
From: Goga777 <goga777@bk.ru>
To: linux-media@vger.kernel.org
Subject: Re: Tevii S650 DVB-S2 diseqc problem
Message-ID: <20090217230640.617a6cba@bk.ru>
In-Reply-To: <854d46170902161521g1ad03be0s1114799fe296df14@mail.gmail.com>
References: <59463.79.136.92.202.1234820777.squirrel@webmail.bahnhof.se>
	<854d46170902161521g1ad03be0s1114799fe296df14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > My server have Ubuntu 8.10 amd64 with a custom kernel and drivers and tools
> > compiled from these sources.
> > http://mercurial.intuxication.org/hg/szap-s2
> > http://mercurial.intuxication.org/hg/s2-liplianin/
> >
> > The scan-s2 utility only find channels from latest used transponder in VDR

you should indicate in ini file the rolloff = 35 because cx24116 doesn't support rolloff = auto 
fresh correct ini files for scan-s2 with rolloff = 35 you can download from here
http://www.vdr-settings.com/download/channels/CLyngsatSP.tar.bz2




Goga
