Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.237])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JOBN5-0004oB-MG
	for linux-dvb@linuxtv.org; Sun, 10 Feb 2008 13:33:23 +0100
Received: by wx-out-0506.google.com with SMTP id s11so3613684wxc.17
	for <linux-dvb@linuxtv.org>; Sun, 10 Feb 2008 04:33:22 -0800 (PST)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sun, 10 Feb 2008 13:33:12 +0100
References: <7F617908C1141A46841994B57C97FB9B04621F52@E03MVZ3-UKDY.domain1.systemhost.net>
In-Reply-To: <7F617908C1141A46841994B57C97FB9B04621F52@E03MVZ3-UKDY.domain1.systemhost.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802101333.12804.christophpfister@gmail.com>
Subject: Re: [linux-dvb] uk-Sudbury dvb-t tuning data file question.
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

Hi,

Am Dienstag 05 Februar 2008 schrieb steve.goodey@bt.com:
> Hello,
>
> Apologies if this is the wrong list to ask.
>
> Perhaps you could answer a few questions for me?
>
> Sudbury, in England, is one of the sites with two DVB-T transmitters,
> Sudbury and SudburyB, main transmitter Tacolneston. On my Mythtv box I
> have found /usr/share/doc/dvb-utils/examples/scan/dvb-t/uk-SudburyB but
> there is no file for Sudbury. Now according to the www.ukfree.tv site
> Sudbury has six muxes, SudburyB has only one for ITV. I suspect I am
> missing something here, why is there only one frequency file for Sudbury
> and why is called SudburyB?

I guess it's just wrongly named; will fix that.

> Should there be two files, as for Dover for example, uk-Sudbury with six
> muxes and uk_SudburyB with one?

Geographically close transmitters should be in a single file; oh well, will 
fix that, too ...

> I assume MythTv does not use these files during tuning?
>
> Regards,
>
> Steve Goodey

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
