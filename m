Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <shaun@saintsi.co.uk>) id 1JMTGv-0002hD-VK
	for linux-dvb@linuxtv.org; Tue, 05 Feb 2008 20:15:57 +0100
From: Shaun <shaun@saintsi.co.uk>
To: linux-dvb@linuxtv.org
Date: Tue, 5 Feb 2008 19:15:26 +0000
References: <7F617908C1141A46841994B57C97FB9B04621F52@E03MVZ3-UKDY.domain1.systemhost.net>
In-Reply-To: <7F617908C1141A46841994B57C97FB9B04621F52@E03MVZ3-UKDY.domain1.systemhost.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802051915.26119.shaun@saintsi.co.uk>
Subject: Re: [linux-dvb] uk-Sudbury dvb-t tuning data file question.
Reply-To: shaun@saintsi.co.uk
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

Hi Steve,

I found that the best method is to use mythtv  to tune, no special files 
required. Just use mythtv-setup and it should work. Id did for me and I am in 
Kent using a Nova 500 DVB-T.

Cheers
Shaun

On Tuesday 05 February 2008 10:36:17 steve.goodey@bt.com wrote:
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
>
> Should there be two files, as for Dover for example, uk-Sudbury with six
> muxes and uk_SudburyB with one?
>
> I assume MythTv does not use these files during tuning?
>
> Regards,
>
> Steve Goodey
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
