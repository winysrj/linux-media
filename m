Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n20.bullet.mail.ukl.yahoo.com ([87.248.110.137])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <r.schedel@yahoo.de>) id 1JmI6n-0002JP-HM
	for linux-dvb@linuxtv.org; Thu, 17 Apr 2008 02:36:14 +0200
Message-ID: <48066F62.8000709@yahoo.de>
Date: Wed, 16 Apr 2008 23:28:02 +0200
From: Robert Schedel <r.schedel@yahoo.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47F9E95D.6070705@yahoo.de>
	<200804120100.14568@orion.escape-edv.de>
In-Reply-To: <200804120100.14568@orion.escape-edv.de>
Content-Type: multipart/mixed; boundary="------------000706050701090105010600"
Subject: Re: [linux-dvb] High CPU load in "top" due to budget_av slot polling
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------000706050701090105010600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Oliver Endriss wrote:
> Robert Schedel wrote:
>> Hello,
>>
>> on 2.6.24 I run into a small issue with the budget_av driver:
>>
>> Hardware: Athlon 64X2 3800+, Satelco Easywatch DVB-C (1894:002c), no CI/CAM
>> Software: Linux kernel 2.6.24 (gentoo-r4) SMP x86_64, budget_av module
>>
>> Error description:
>> After the budget_av driver module is loaded (even without any DVB 
>> application), the CPU load average in 'top' rises to ~1, but in top no 
>> active tasks are found. After unloading the driver, the load decreases 
>> again to ~0.
>>
>> Displaying the blocked tasks during high load with Alt-SysRq-W shows 
>> that the kdvb-ca kernel thread seems to be accounted as blocked when it 
>> polls for the CI slot status:
>> ---------------------------------------------------
>> [...]
>> ---------------------------------------------------
>>
>> Enabling debug traces shows that polling for the PSR in function 
>> 'saa7146_wait_for_debi_done_sleep' constantly times out after 250x1ms 
>> sleeps:
>>
>>  > saa7146: saa7146_wait_for_debi_done_sleep(): saa7146 (0): 
>> saa7146_wait_for_debi_done_sleep timed out while waiting for transfer 
>> completion
>>
>> Increasing the 250ms did not avoid the timeout. And as I understood from 
>> previous list mails, this timeout is normal when no CI/CAM is connected 
>> to the DEBI. However, for me the high frequency polling does not make 
>> sense if someone does not plan to plug in a CI/CAM.
>>
>> When commenting out two lines in 'dvb_ca_en50221_thread_update_delay' to 
>> increase the polling timer for slotstate NONE from 100ms (!) to 60s, the 
>> CPU load went down to 0. So this is some kind of workaround for me.
> 
> Afaics the polling interval could be increased to something like 5s or
> 10s if (and only if) the slot is empty. Could you provide a patch?

Attached a patch for 2.6.24.4. Opinions?

Unfortunately, a 5s poll interval for empty slots still results in a
load average of about 0,06 (~ 250ms/5s).

Increasing to 10s would decrease the load and be fine for people without
CAM, but increase the delay for those users inserting CAMs during
runtime. 5s sounds like a reasonable tradeoff.

Is the 250ms timeout an approved limit? Decreasing it would push the
load further down. Probably it still has to cover slow CAMs as well as a
stressed PCI bus. Unfortunately, without CAM/CI I cannot make any
statements myself.

>> Finally, my questions:
>> 1. Did I understand this right, that the behaviour above is expected 
>> when no CI is connected?
> 
> Yes, but afaics the polling interval is way too short.
> 
>> 2. Are all budget_av cards unable to check CAM slot state via interrupt 
>>   for HW reasons (as budget_ci does)?
> 
> I don't have any budget-av hardware, so I don't know.
> But I think that Andrew(?) had a good reason to implement it this way.
> (In contrast the budget-ci driver was always interrupt-driven.)
> 
> If someone finds out that a given card can operate in interrupt mode,
> it should be changed for this card. Patches are welcome. ;-)

My impression is, due to the different GPIO layout there is no way to
get a CAM change IRQ. But it seems difficult to get information about
the HW architecture of cards at all.

Regarding DEBI_E: Just found a av7110 code comment which also reflects
what my recent tests showed:
          /* Note: Don't try to handle the DEBI error irq (MASK_18), in
           * intel mode the timeout is asserted all the time...
           */

So really only DEBI_S would be left, see below.

>> 3. Would it be possible to substitute the current PSR DEBI_S polling 
>> with an interrupt based solution via IER/ISR? (driver av7110 alreadys 
>> seems to do this for its DEBI DMA)? Or was this not considered worthy, 
>> due to the expected short waiting period and the tricky IER handling? 
>> The code does not state further thoughts about this.
> 
> The av7110 driver uses interrupt mode for buffer transfers in dma mode.
> It does not make much sense to use interrupt mode for single-word
> transfers, because the single-word transfers are very fast.
> But I understand that the timeout causes a problem in this case.

OK, interrupts of course decrease performance in the "sunny day" cases
(=communication with inserted card in slot state READY). Having both
approaches (interrupt when slotstate empty, later polling) would combine
all benefits but also be somewhat crazy.

>> 4. Are the high timeout periods in debi_done (50ms/250ms) in relation to 
>> the 100ms poll timer intended? (I found the recent patch to this code in 
>> the mailing list end of last year)
> 
> That patch was applied to reduce the load on the pci bus in busy-wait
> mode. Basically it did not change anything for cam polling. (In fact I
> was not aware that the CAM was polled every 100ms. Imho this should be
> fixed.)

Only wondered whether the 250ms might have been smaller in former driver
versions.

> 
>> 5. If we would be restricted to poll with high frequency: Why not at 
>> least allow users without CI to disable polling for slots or change the 
>> interval, e.g. via module options?
> 
> Module options are evil. ;-)
> We should do this only if everything else fails.

Correct.

P.S. Had already created bugzilla #10459 for tracking.
Sorry for late response, previous mail was stuck in spam filter.

Regards,
Robert


--------------000706050701090105010600
Content-Type: text/plain;
 name="incr-empty-ca-slot-poll-2.6.24.4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="incr-empty-ca-slot-poll-2.6.24.4.patch"

From: Robert Schedel <r.schedel@yahoo.de>

This change addresses kernel bug #10459: In kernel 2.6.24 the
budget_av driver polls for an CI slot in 100ms intervals (because no
interrupt solution for budget_av cards is feasible due to HW reasons).
If no CI/CAM is connected to the DVB card, polling times out only after 250ms.
This periodic polling leads to high CPU load.

The change increases the polling interval for empty slots from 100ms to 5s.
Intervals for remaining slot states (invalid, in progress, ready) are unchanged,
as they are either temporary conditions or no timeout should occur.

Signed-off-by: Robert Schedel <r.schedel@yahoo.de>

---
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |   20 ++++++++++++------
  1 file changed, 14 insertions(+), 6 deletions(-)

diff -rupN linux-2.6.24.4-orig/drivers/media/dvb/dvb-core/dvb_ca_en50221.c linux-2.6.24.4/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
--- linux-2.6.24.4-orig/drivers/media/dvb/dvb-core/dvb_ca_en50221.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24.4/drivers/media/dvb/dvb-core/dvb_ca_en50221.c	2008-04-16 21:41:17.000000000 +0200
@@ -910,14 +910,22 @@ static void dvb_ca_en50221_thread_update
 	int curdelay = 100000000;
 	int slot;
 
+	/* Beware of too high polling frequency, because one polling
+	 * call might take several hundred milliseconds until timeout!
+	 */
 	for (slot = 0; slot < ca->slot_count; slot++) {
 		switch (ca->slot_info[slot].slot_state) {
 		default:
 		case DVB_CA_SLOTSTATE_NONE:
+			delay = HZ * 60;  // 60s
+			if (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)) {
+				delay = HZ * 5;  // 5s
+			}
+			break;
 		case DVB_CA_SLOTSTATE_INVALID:
-			delay = HZ * 60;
+			delay = HZ * 60;  // 60s
 			if (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)) {
-				delay = HZ / 10;
+				delay = HZ / 10;  // 100ms
 			}
 			break;
 
@@ -926,18 +934,18 @@ static void dvb_ca_en50221_thread_update
 		case DVB_CA_SLOTSTATE_VALIDATE:
 		case DVB_CA_SLOTSTATE_WAITFR:
 		case DVB_CA_SLOTSTATE_LINKINIT:
-			delay = HZ / 10;
+			delay = HZ / 10;  // 100ms
 			break;
 
 		case DVB_CA_SLOTSTATE_RUNNING:
-			delay = HZ * 60;
+			delay = HZ * 60;  // 60s
 			if (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE)) {
-				delay = HZ / 10;
+				delay = HZ / 10;  // 100ms
 			}
 			if (ca->open) {
 				if ((!ca->slot_info[slot].da_irq_supported) ||
 				    (!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_DA))) {
-					delay = HZ / 10;
+					delay = HZ / 10;  // 100ms
 				}
 			}
 			break;


--------------000706050701090105010600
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000706050701090105010600--
