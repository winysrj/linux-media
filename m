Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail9.dslextreme.com ([66.51.199.94])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <daniel@gimpelevich.san-francisco.ca.us>)
	id 1KDia8-0004Wd-EA
	for linux-dvb@linuxtv.org; Tue, 01 Jul 2008 18:19:56 +0200
Message-ID: <486A57A2.8060904@gimpelevich.san-francisco.ca.us>
Date: Tue, 01 Jul 2008 09:13:22 -0700
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
To: Adam Burdeniuk <burdeniuk@internode.on.net>
References: <4865b170.2e5.6a9b.26067@internode.on.net>
	<486966E8.3050509@internode.on.net>
In-Reply-To: <486966E8.3050509@internode.on.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO FusionHDTV DVB-T Pro
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

Adam Burdeniuk wrote:
> Daniel,
> 
> Please read my comments scattered below.  I had posted this to the 
> linux-dvb mailing list (albeit in a new thread) but it seems to have got 
> lost in the noise.

I am CC'ing the list.

> Daniel Gimpelevich wrote:
>>  Looking at cx88-cards.c, I see that the definition there for your
>>  card is quite broken. I'm amazed it ever worked at all with such
>>  incomplete support.
> 
> There was some preliminary work in 
> http://linuxtv.org/hg/~pascoe/xc-test/ that got DVB-T working with this 
> card in 2.6.24.

That tree was merged into the main v4l-dvb tree.

> Analog TV, composite, svideo, remote controls, etc 
> didn't work (or at least I was told they wouldn't work and I never tried 
> them).  Is that what you mean by 'quite broken'?  I'm not familiar 
> enough with the linuxtv codebase to make judgements of what you mean for 
> myself, but am willing to learn.  All I've really done is applied 
> patches that Chris supplied me.

There is that, but also, I bet that any attempt to try them would have 
made DVB also stop working.

>>  Fundamental portions of the cx88 driver need to be redone, and for
>>  your card, that will mean going back to Windows to see what the
>>  vendor's driver is doing with GPIO in response to different inputs,
>>  as well as some experimentation. If you're up for things like that,
>>  you can start by: 1) Gathering GPIO register values in Windows with
>>  RegSpy from dscaler.org, recording what they are with each card input
>>  selected (DVB, analog TV, composite, S-video, FM radio, SCART, etc.),
>>  as well as the values after closing all apps related to the card, so
>>  that the card is idle.
> 
> Done, at least some preliminary (i.e. non-exhaustive) results.  See the 
> attachment for processed results.

Excellent!

> Even when the card is idle it seems to be doing DMA transfers (as the 
> *DMA* values keep changing).

That is to be expected.

> The one issue that Chris told me about with this card (I don't know if 
> there were any others that he solved before I came along) was:
> 
>>  ...There was some code someone else added to the zl10353 driver that
>>  makes it give up control of the I2C bus.  This isn't appropriate for
>>  this board, because the zl10353 provides the bus power.  If it does
>>  this, everything stops responding - including the eeprom - so things
>>  are messed up... I have disabled this functionality for this board
>>  and put a patch in with the right GPIO settings into:
>>  http://linuxtv.org/hg/~pascoe/xc-test/

This would also be addressed in the fundamental changes I mentioned above.

>>  2) Applying this patch:
>>  http://thread.gmane.org/gmane.comp.video.video4linux/38536 Note that
>>  with the card definition as it currently is, this patch will make the
>>  card stop working altogether. You will need to redo the card
>>  definition to include all the info gathered in #1 above.
> 
> What revision should I apply this patch to?  What information do I put 
> where?

It would be applied to the current mercurial tip of the main v4l-dvb 
tree. After doing that, replace the card definition in cx88-cards.c for 
your card with one based on the data you provided. That would be:
         [CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO] = {
                 .name           = "DViCO FusionHDTV DVB-T PRO",
                 .tuner_type     = TUNER_ABSENT, /* XXX: Has XC3028 */
                 .radio_type     = UNSET,
                 .tuner_addr     = ADDR_UNSET,
                 .radio_addr     = ADDR_UNSET,
                 .input          = { {
                         .type   = CX88_VMUX_TELEVISION,
                         .vmux   = 0,
                         .gpio0  = 0x00001ef5,
                 }, {
                         .type   = CX88_VMUX_COMPOSITE1,
                         .vmux   = 1,
                         .gpio0  = 0x00001ef1,
                 }, {
                         .type   = CX88_VMUX_SVIDEO,
                         .vmux   = 2,
                         .gpio0  = 0x00001ef1,
                 }, {
                         .type   = CX88_VMUX_DVB,
                         .gpio0  = 0x00001ef5,
                 } },
                 .off = {
                         .type   = CX88_OFF,
                         .gpio0  = 0x00001ef5,
                 },
                 .mpeg           = CX88_MPEG_DVB,
         },

>>  3) Reporting your findings from #1 and #2 above. I will be submitting
>>  a patch to the tuner-core that will pave the way for some real fixing
>>  of cx88, and info on as many cx88 cards as possible will be a plus
>>  during that fixing.
>>  4) Testing future cutting-edge patches to see how
>>  they affect the use of the card, before those patches make it into
>>  the tree.
> 
> Fine by me.
> 
>>  Have fun!
> 
> Thanks,
> Adam

OK, after applying the patch and replacing the card definition, please 
try under Linux everything you did under Windows, so that you may report 
back any observable differences between the two. While they might not 
all be taken care of in the short term, a catalog of them now would be a 
resource for future improvements.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
