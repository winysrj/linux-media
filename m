Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from viefep27-int.chello.at ([62.179.121.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rscheidegger_lists@hispeed.ch>) id 1Jy9Sv-0001et-A3
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 19:48:06 +0200
Message-ID: <4831BD2A.3040609@hispeed.ch>
Date: Mon, 19 May 2008 19:47:22 +0200
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: Pauli Borodulin <pauli@borodulin.fi>
References: <482E114E.1000609@borodulin.fi>	<d9def9db0805161621n1a291192n8c15db11949b3dad@mail.gmail.com>
	<4831B058.1030107@borodulin.fi>
In-Reply-To: <4831B058.1030107@borodulin.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Updated Mantis VP-2033 remote control patch for
 Manu's jusst.de Mantis branch
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

On 19.05.2008 18:52, Pauli Borodulin wrote:
> Heya!
> 
>> On 5/17/08, Pauli Borodulin <pauli@borodulin.fi> wrote:
>>> Since there has been some direct requests for this via email, I'm
>>> posting a updated version of Kristian Slavov's original remote control
>>> patch[1] for Manu's jusst.de Mantis branch. The new version is
>>> functionally the same as the one I posted in March[2].
>>> [...]
> 
> Markus Rechberger wrote:
>> +int mantis_rc_exit(struct mantis_pci *mantis)
>>  +{
>>  +        mmwrite(mmread(MANTIS_INT_MASK) & (~MANTIS_INT_IRQ1),
>> MANTIS_INT_MASK);
>>  +
>>  +        cancel_delayed_work(&mantis->ir.rc_query_work);
>>  +        input_unregister_device(mantis->ir.rc_dev);
>>  +        dprintk(verbose, MANTIS_DEBUG, 1, "RC unregistered");
>>  +        return 0;
>>  +}
>>
>> this might be dangerous when unloading the driver because the callback
>> function might still be running after cancel_delayed_work.
>> I ran into that problem a while ago and it could lock up the whole
>> input system.
>> [...]
> 
> Thanks Markus! I created a revised version of the patch with call to
> flush_scheduled_work() after calling cancel_delayed_work. I also changed
> RC polling a bit so that it would work alike on different kernel
> configurations (thanks go to Kristian Slavov for pointing this out).
> 
> The patch is against
> http://www.jusst.de/hg/mantis/archive/b14e79e460fc.tar.bz2.

No offense, but I like my patch much better :-) [1]. I fail to see why
polling has to be done - just for half-working (at best on some cards,
not at all if the native repeat rate is too low) "improved" auto-repeat.

I was under the impression that using cancel_rearming_delayed_work
instead of cancel_delayed_work (as I did in my patch) would make it
unnecessary to call flush_scheduled_work (but I just followed some other
drivers and could be easily wrong).

As for the IR codes being in common ir code, I didn't care but the
dvb-usb driver also uses its own tables - though I see this driver
probably has reasons to do so.

[1]http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026102.html


Roland


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
