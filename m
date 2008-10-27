Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KuWaR-0004bU-DK
	for linux-dvb@linuxtv.org; Mon, 27 Oct 2008 19:13:08 +0100
Received: by ey-out-2122.google.com with SMTP id 25so904646eya.17
	for <linux-dvb@linuxtv.org>; Mon, 27 Oct 2008 11:13:04 -0700 (PDT)
Message-ID: <37219a840810271113u71569921p1e86064223362fb7@mail.gmail.com>
Date: Mon, 27 Oct 2008 14:13:03 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "BOUWSMA Barry" <freebeer.bouwsma@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0810271752490.29514@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Disposition: inline
References: <200810251101.11569@centrum.cz> <200810251102.1298@centrum.cz>
	<200810251103.27574@centrum.cz> <200810251103.16869@centrum.cz>
	<alpine.LRH.1.10.0810261537420.8807@pub2.ifh.de>
	<alpine.DEB.2.00.0810271752490.29514@ybpnyubfg.ybpnyqbznva>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API: Future support for DVB-T2
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

On Mon, Oct 27, 2008 at 1:54 PM, BOUWSMA Barry
<freebeer.bouwsma@gmail.com> wrote:
> On Sun, 26 Oct 2008, Patrick Boettcher wrote:
>
>> Adding support to the API is only part of the job. The question is which
>> currently available receiver hardware is supporting DVB-T2 and where can we
>
> Apparently the following were used at a recent demo in Amsterdam:
> Tuner chip TDA18211HN, prototype demodulator TDA10055, both from
> NXP.
>
>
>
>> get a driver for this hardware?
>
> Won't it be that some poor sucker signs away their soul for NDA
> access to the specifics of the chips, or is it possible that
> the chip manufacturer might deliver already-written drivers
> (though looking at the existing TDAxxxxx frontend code, the
> former seems most likely, and I don't know how well this one
> manufacturer is generally with linux support) ?
>
> Support for the tuner chip above seems to have been attempted
> about a year ago.

The TDA18211HN is fully supported by the tda18271 module.  The driver
will not need anything specific to tune into new broadcast standards
-- just the filters need to be set up properly.

All of the differences in setup are exposed by the driver in the
attach-time configuration structure, so the driver would not need any
modification to work properly with new demodulator hardware, other
than some tweaking in the attach-time configuration structure
overrides.  (without the overrides, the driver will use default
behavior, which is appropriate for some but not all designs).

I do not know of anybody working on a driver for the tda10055.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
