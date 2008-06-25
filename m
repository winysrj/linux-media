Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marko.ristola@kolumbus.fi>) id 1KBbid-0002cL-RE
	for linux-dvb@linuxtv.org; Wed, 25 Jun 2008 22:35:56 +0200
Message-ID: <4862AC25.1030507@kolumbus.fi>
Date: Wed, 25 Jun 2008 23:35:49 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <4861501B.9050507@kolumbus.fi>
	<d9def9db0806250508s60dcc01cjecb56bdaa9c0abb3@mail.gmail.com>
In-Reply-To: <d9def9db0806250508s60dcc01cjecb56bdaa9c0abb3@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Ticlkess Mantis remote control implementation
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

Markus Rechberger wrote:
> Hi Marko,
>
> On 6/24/08, Marko Ristola <marko.ristola@kolumbus.fi> wrote:
>   
>> Hi,
>>
>> I have still my own version of Manu's jusst.de/mantis driver that is
>> based on v4l-dvb-linuxtv main branch,
>> mainly because I use so new Linux kernels.
>> I have done the following improvement lately:
>>
>> I implemented a remote control patch, that doesn't poll the remote
>> control all the time.
>> It polls the remote control only if you press the button (a tickless
>> version, you know).
>> It surprised me, that the actual implementation was really small, it
>> took very few lines of code.
>>     

>>
>>
>> mantis_rc.c:
>> #define POLL_FREQ (HZ/4)
>>
>>     
>
> maybe msecs_to_jiffies(250) would be easier to understand here?
>   
Sounds good,
maybe something like

#define RC_REPEAT_DELAY msecs_to_jiffies(300)

So the increase into 300 is because the initial remote control delay 
might be about 270ms.
Further delays might be 220ms.
This way the delay is safely big enough.

Roland has done another tickless implementation that obeys 270ms and 
220ms delays exactly.
It might be even better now for VDR style applications than my 
implementation.

It is on http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026102.html.

Marko
> Markus
>
>   
>> void mantis_query_rc(struct work_struct *work)
>> {
>>        struct mantis_pci *mantis =
>>                container_of(work, struct mantis_pci,
>> ir.rc_query_work.work);
>>        struct ir_input_state *ir = &mantis->ir.ir;
>>
>>        u32 lastkey = mantis->ir.ir_last_code;
>>
>>        ir_input_nokey(mantis->ir.rc_dev, ir);
>>
>>        if (lastkey != -1) {
>>                ir_input_keydown(mantis->ir.rc_dev, ir, lastkey, 0);
>>                mantis->ir.ir_last_code = -1;
>>                schedule_delayed_work(&mantis->ir.rc_query_work, POLL_FREQ);
>>        }
>> }
>>
>> int mantis_rc_init(struct mantis_pci *mantis):
>>        mantis->ir.ir_last_code = -1; /* key presses disabled here. */
>>        INIT_DELAYED_WORK(&mir->rc_query_work, mantis_query_rc);
>>
>> int mantis_rc_exit(struct mantis_pci *mantis):
>>
>>        mmwrite(mmread(MANTIS_INT_MASK) & (~MANTIS_INT_IRQ1),
>> MANTIS_INT_MASK);
>>        mantis->ir.ir_last_code = -1; /* key presses disabled here. */
>>        cancel_delayed_work_sync(&mantis->ir.rc_query_work); /* not my
>> idea */
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>     
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
