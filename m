Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JPMBZ-0005V8-UO
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 19:18:21 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Wed, 13 Feb 2008 19:17:50 +0100
References: <200802071023.28160.hubblest@web.de>
In-Reply-To: <200802071023.28160.hubblest@web.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802131917.50626.zzam@gentoo.org>
Subject: Re: [linux-dvb] AVerMedia DVB-S Hybrid+FM and DVB-S Pro [A700]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Donnerstag, 7. Februar 2008, Peter Meszmer wrote:
> Hello,
>
> I'm watching this list for quite a while now, looking forward to see my
> Avermedia AVerTV DVB-S Hybrid+FM supported.
> This card looks very similar to the Avermedia AVerTV DVB-S Pro [A700], so I
> tried the two existing patches. Finally, Matthias Schwarzott's (zzam)
> patch "a700_full_20080204" did it.
>
> DVB-S is working very well using Kaffeine 0.8.5, input via S-Video or
> Composite worked, since I bought the card, and is still working.
>
> Is it possible, to add the cards ID (1461:a7a2) to the list?
>
I uploaded a new patch that has this pci id added to the list.

Regards
Matthias

-- 
Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
