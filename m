Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1LHSEo-0004a4-Me
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 01:13:35 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1833894fga.25
	for <linux-dvb@linuxtv.org>; Mon, 29 Dec 2008 16:13:31 -0800 (PST)
Message-ID: <19a3b7a80812291613kc566f0cua89156b43f1ec7d7@mail.gmail.com>
Date: Tue, 30 Dec 2008 01:13:30 +0100
From: "Christoph Pfister" <christophpfister@gmail.com>
To: "Koos van den Hout" <koos@kzdoos.xs4all.nl>
In-Reply-To: <20081224112111.GA15004@kzdoos.xs4all.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081224112111.GA15004@kzdoos.xs4all.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Scan file dvb-t nl-Utrecht
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

2008/12/24 Koos van den Hout <koos@kzdoos.xs4all.nl>:
> As attached, tested yesterday evening with scan from Ubuntu dvb-utils
> 1.1.1-3.
>
> I see fec values in nl-Randstad and nl-AlphenaandenRijn that aren't valid
> (anymore) compared to the information source I have. Should I send those
> in with my 'theoretical' fixes or should I wait until I can try them (or
> ask people to try them).

Those nl-* files were removed in favour of a nl-All file 11 months
ago. I've recreated the nl-All file as some channels have changed
since then [1], so all issues should be solved now.

Christoph


>                                          Koos van den Hout
>
> --
> Koos van den Hout                         Homepage: http://idefix.net/~koos/
>                        PGP keyid DSS/1024 0xF0D7C263 or RSA/1024 0xCA845CB5
> Webprojects:              Camp Wireless        http://www.camp-wireless.org/
>                      The Virtual Bookcase   http://www.virtualbookcase.com/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
