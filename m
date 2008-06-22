Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rouge.crans.org ([138.231.136.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <braice@braice.net>) id 1KAMtn-0002QM-Ti
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 12:34:34 +0200
Message-ID: <485E2AA5.6070108@braice.net>
Date: Sun, 22 Jun 2008 12:34:13 +0200
From: Brice DUBOST <braice@braice.net>
MIME-Version: 1.0
To: Halim Sahin <halim.sahin@t-online.de>
References: <20080622092133.GA21319@halim.local>
In-Reply-To: <20080622092133.GA21319@halim.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvbscan errormessage on astra 19.0
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Halim Sahin a =E9crit :
> Hello,
> =

> I.ve scanned today astra with the initial list of dvb-apps from hg.
> It finished with the following message:
>>>> tune to: 1574:h:S19.2E:22000:
> __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
> 22 Invali
> d argument
>>>> tune to: 1574:h:S19.2E:22000:
> __tune_to_transponder:1483: ERROR: Setting frontend parameters failed:
> 22 Invali
> d argument
> =

> My card is a kncone dvbstar =

> What can be the problem here?
> =


Hello

try "strace scan ..."

And give us the output

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
