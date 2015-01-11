Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:50155 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbbAKKfS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2015 05:35:18 -0500
Message-ID: <54B24FB9.6010401@schinagl.nl>
Date: Sun, 11 Jan 2015 11:26:01 +0100
From: Olliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Adam Laurie <adam@algroup.co.uk>,
	Jonathan McCrohan <jmccrohan@gmail.com>,
	Brian Burch <brian@pingtoo.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb-t scan tables
References: <54ADCBBC.4050400@algroup.co.uk> <54AE4333.9070301@schinagl.nl> <54AE4A6D.6080602@pingtoo.com> <54AE4DE6.1040602@schinagl.nl> <92F63096-11DC-434E-81C0-673263E56459@gmail.com> <54AE9066.8010000@algroup.co.uk>
In-Reply-To: <54AE9066.8010000@algroup.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Adam,

I've merged your changes, but this last patch seems to go against the 
old (obsolete) dvbv3 stuff (that gets auto-generated afaik) and fails to 
apply.

Look at the result on the various repositories and see what needs to be 
changed.

Best way to send a patch, is to use git to checkout the tree, and then 
do a git format-patch to send the patch, saves me some work ;)

Olliver


On 01/08/2015 03:12 PM, Adam Laurie wrote:
> On 08/01/15 13:16, Jonathan McCrohan wrote:
>
>> Submitting a bug against dtv-scan-tables to the Debian/Ubuntu bug tracker isn't the worst thing in the world; I maintain the package in Debian and keep it up to date. Ubuntu then syncs the package from Debian. I monitor both bug trackers for bug reports and send any upstream.
>>
>> Best to send them directly upstream to linux-media@vger.kernel.org if you can manage it though :-)
>>
> Unfortunately the tables in /usr/share/dvb are even more broken and I
> have no simple way of testing any patch, but I would suggest they could
> be auto-generated from the correct one we've just created.
>
>
> As you can see, it's not just the frequencies that are wrong, but FEC
> and MOD etc:
>
>
>> $ cat /usr/share/dvb/dvb-t/uk-StocklandHill
>> # UK, Stockland Hill
>> # http://www.ukfree.tv/txdetail.php?a=ST222014
>> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
>> T 514167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE     # PSB1
>> T 490167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE     # PSB2
>> #T 538167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE     # PSB3 (DVB-T2)
>> T 505833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE     # COM4
>> T 481833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE     # COM5
>> T 529833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE     # COM6
>
> For what it's worth, here is the patch, untested. If you're happy with
> it, I'll certainly send it to linux-media@vger.kernel.org - your call.
>
> cheers,
> Adam

