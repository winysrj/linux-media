Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.233])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Jx9Ey-0007aO-IZ
	for linux-dvb@linuxtv.org; Sat, 17 May 2008 01:21:33 +0200
Received: by rv-out-0506.google.com with SMTP id b25so490413rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 16 May 2008 16:21:28 -0700 (PDT)
Message-ID: <d9def9db0805161621n1a291192n8c15db11949b3dad@mail.gmail.com>
Date: Sat, 17 May 2008 01:21:27 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Pauli Borodulin" <pauli@borodulin.fi>
In-Reply-To: <482E114E.1000609@borodulin.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <482E114E.1000609@borodulin.fi>
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

Hi Pauli,

On 5/17/08, Pauli Borodulin <pauli@borodulin.fi> wrote:
> Heya!
>
> Since there has been some direct requests for this via email, I'm
> posting a updated version of Kristian Slavov's original remote control
> patch[1] for Manu's jusst.de Mantis branch. The new version is
> functionally the same as the one I posted in March[2].
>
> I have adapted the patch for the current driver tree and moved ir_codes
> back to ir-keymaps.c & ir-common.h to follow the standard kernel
> procedure for the IR stuff. The patch is against the current driver tree
> (cd1fc4c7f1d8).
>
> [1] http://www.linuxtv.org/pipermail/linux-dvb/2007-April/017279.html
> [2] http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024301.html
>
> Regards,
> Pauli Borodulin
>
+int mantis_rc_exit(struct mantis_pci *mantis)
 +{
 +        mmwrite(mmread(MANTIS_INT_MASK) & (~MANTIS_INT_IRQ1),
MANTIS_INT_MASK);
 +
 +        cancel_delayed_work(&mantis->ir.rc_query_work);
 +        input_unregister_device(mantis->ir.rc_dev);
 +        dprintk(verbose, MANTIS_DEBUG, 1, "RC unregistered");
 +        return 0;
 +}

this might be dangerous when unloading the driver because the callback
function might still be running after cancel_delayed_work.
I ran into that problem a while ago and it could lock up the whole input system.

There's also a note in the kernelheaders:
/*
 * Kill off a pending schedule_delayed_work().  Note that the work callback
 * function may still be running on return from cancel_delayed_work().  Run
 * flush_scheduled_work() to wait on it.
 */
include/linux/workqueue.h

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
