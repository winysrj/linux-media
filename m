Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:63965 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbZBZNA4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 08:00:56 -0500
Received: from pub3.ifh.de (pub3.ifh.de [141.34.15.119])
	by znsun1.ifh.de (8.12.11.20060614/8.12.11) with ESMTP id n1QD0iQw001689
	for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 14:00:44 +0100 (MET)
Received: from localhost (localhost [127.0.0.1])
	by pub3.ifh.de (Postfix) with ESMTP id 98C5215819D
	for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 14:00:44 +0100 (CET)
Date: Thu, 26 Feb 2009 14:00:44 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] writing DVB recorder, questions
In-Reply-To: <S79054AbZBZM2acYeFs/20090226122830Z+688@nic.funet.fi>
Message-ID: <alpine.LRH.1.10.0902261346190.25917@pub3.ifh.de>
References: <S79054AbZBZM2acYeFs/20090226122830Z+688@nic.funet.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Juhana,

On Thu, 26 Feb 2009, Juhana Sadeharju wrote:
> Hello. I started writing a simple DVB recorder, dvbrec. Perhaps
> it later evolves to program such as Klear, which indeed is
> clearest thing I have seen among DVB programs (but misses subtitles).
>
> The complete stream has too much of data: 10 GB per hour.
> As solution, existing recorders seems to pick only parts of the
> whole stream (audio and video of one channel), missing many
> features, including subtitles. The idea seems to be to drop
> the parts that are unwanted and unknown (to author).
>
> Perfect recording requires more. My idea is to pick all what comes
> and drop the known parts: audio and video of the unwanted channels.
> This leaves subtitles, alternative languages, robovoice, epg,
> text-tv, etc. intact.

I'm not answering to your question and I don't know about Robovoice, but 
for the rest VDR could do it for you. Either with plugins or (most of it) 
native.

VDR in conjunction with vdr-xineliboutput can be nicely integrated in 
Desktop or dedicated SetTopBox-replacement environments.

If I were you, I'd give it a try :)

Patrick.
