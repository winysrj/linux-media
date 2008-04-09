Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <greg.d.thomas@gmail.com>) id 1Jjdva-00029j-S0
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 19:17:43 +0200
Received: by an-out-0708.google.com with SMTP id d18so656831and.125
	for <linux-dvb@linuxtv.org>; Wed, 09 Apr 2008 10:17:38 -0700 (PDT)
Message-ID: <e28a31000804091017u531b05e7jdb444bc171e91448@mail.gmail.com>
Date: Wed, 9 Apr 2008 18:17:38 +0100
From: "Greg Thomas" <Greg@TheThomasHome.co.uk>
To: linux-dvb@linuxtv.org
In-Reply-To: <47FC8DE0.3060202@dsl.pipex.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <mailman.99.1207695038.954.linux-dvb@linuxtv.org>
	<47FC8DE0.3060202@dsl.pipex.com>
Subject: Re: [linux-dvb] WinTV-NOVA-TD & low power muxes (Philip Pemberton)
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

On 09/04/2008, David Harvey <dcharvey@dsl.pipex.com> wrote:
>>
>>  Greg Thomas wrote:
>>
>>  > /> After trying the latest drivers, I had a go under Windows; exactly the
>>  > > same set of channels. I just guess the Nova-TD isn't that sensitive. I
>>  > > may just have to look at boosting my signal, somehow  :( /
>>  >
>>  /
>>
>>  The Nova-TD seems to have an odd problem. Specifically, it seems
to have some
>>  form of wideband low-gain amplifier/buffer on each aerial input
(nothing like
>>  the high-gain narrowband LNA amplifier on the Nova-T-500). This takes into.
>>  account the strongest muxes, not the mux you're currently tuned to (the T500
>>  seems to do the latter -- which is more sensible).
>
>  I vaguely remember someone mentioning this problem doesn't affect the TD
>  card/stick under the Windows driver.  Can anyone confirm this?

My experience was that I picked up the same channels with the
out-of-the box windows drivers as I did with the Linux drivers.

Greg

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
