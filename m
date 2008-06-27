Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KCF5g-0000kq-ML
	for linux-dvb@linuxtv.org; Fri, 27 Jun 2008 16:38:22 +0200
Received: by yx-out-2324.google.com with SMTP id 8so148377yxg.41
	for <linux-dvb@linuxtv.org>; Fri, 27 Jun 2008 07:38:16 -0700 (PDT)
Message-ID: <37219a840806270738u6a456c95q4699b67e03210f98@mail.gmail.com>
Date: Fri, 27 Jun 2008 10:38:16 -0400
From: "Michael Krufky" <mkrufky@gmail.com>
To: free_beer_for_all@yahoo.com
In-Reply-To: <555109.53449.qm@web46109.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <555109.53449.qm@web46109.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with Terratec Cinergy Piranha
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

On Wed, Jun 25, 2008 at 4:05 AM, barry bouwsma
<free_beer_for_all@yahoo.com> wrote:
> Sorry for breaking the References: header; I'm pasting between
> web browsers here, and this message was posted before I suscirbed
>
> Esa Hyytia wrote:
>
>> I bought today this USB stick (187f:0010) and tried to get it work in 32-bit Ub
>> untu 8.04:
>
>>  - Driver snapshot from today (http://linuxtv.org/hg/~mkrufky/siano)
>>  - Firmware is extracted from driver-cd (same as from terratec.net)
>>  - I also changed 'default_mode' to 0 in smscoreapi.c
>
> That's your mistake -- now for DVB-T the default mode needs to be
> left as 4 (that's DVBT-DBA-drivers; how that specifically differs
> from mode 0 DVB-T I have no idea, but that's the way it is now)

This is an experimental driver -- You'll notice that I did not merge
it into the master branch yet -- those alternative modes are for
external software applications, to use the driver in a way without
using the dvb core framework.

I plan to remove that from the driver, as I am working to convert it
100% to the standard linux-dvb api.

default_mode is set to 4 in the driver -- you just shouldn't mess with it.

> Only mode 4 will work with yesterday's /siano snapshot, even
> though the firmware is the same -- you'll also need to rename the
> firmware to what the code expects:
> dvbt_bda_stellar_usb.inp
>
> There appears to be another copy of the smsdvb code in a repository
> called somehow `hd' which differs slightly; the only difference I
> looked at is one which I needed to apply for my 2.6.24-era kernel.
> I need to look more closely at what else differs.

That code is not for you :-P  That's for an unrelated experiment that
I was doing.

You think you needed the adapter_nr compat patch, but you dont -- if
you build from the "siano" tree, it will install the newer dvb-core
along with the adapter_nr interface.

Just dont use the hd tree.

The "isms" will all be removed before I merge the code into the master
repository.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
