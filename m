Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40276 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0FXSyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 14:54:20 -0400
Received: by bwz7 with SMTP id 7so351293bwz.19
        for <linux-media@vger.kernel.org>; Thu, 24 Jun 2010 11:54:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimDPMjN1OF7zKHqn2JOYoUm4DFq2VRwQJAICThX@mail.gmail.com>
References: <AANLkTimDPMjN1OF7zKHqn2JOYoUm4DFq2VRwQJAICThX@mail.gmail.com>
Date: Thu, 24 Jun 2010 20:54:18 +0200
Message-ID: <AANLkTilRgPW_GfyOAMWBUl7hUvbFSKKuEERo8MVlLoXp@mail.gmail.com>
Subject: Re: Update to tuning file frequencies for au-Brisbane location to
	include a new channel
From: Christoph Pfister <christophpfister@gmail.com>
To: Jared Norris <jrnorris@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Updated, thanks!

Christoph


2010/6/23 Jared Norris <jrnorris@gmail.com>:
> Good morning,
>
> I would like to include an update in the auto tune file for the
> /dvb/dvb-t/au-Brisbane file as there has recently been an additional
> channel added to the area. If you can please add the following 2 lines
> to the file that would be appreciated.
>
> # 31 Digital
> T 599500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
>
> It is appropriate for it to be at the end of the list so the whole
> file would look like (just in case it makes it easier for you than a
> single line in isolation):
>
> # Australia / Brisbane (Mt Coot-tha transmitters)
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> # ABC
> T 226500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
> # Seven
> T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
> # Nine
> T 191625000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
> # Ten
> T 219500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
> # SBS
> T 585625000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
> # 31 Digital
> T 599500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
>
> I hope this is enough information for your requirements. I have tested
> this on several devices under several dvb applications and from what I
> can see the options are all correct. If further information or testing
> is required please let me know and I will happily help out. Thanks for
> your time.
>
> Regards,
>
> Jared Norris
