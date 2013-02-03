Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49043 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab3BCT1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 14:27:17 -0500
Received: by mail-lb0-f179.google.com with SMTP id j14so6108385lbo.10
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 11:27:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510E645A.80103@iki.fi>
References: <50F05C09.3010104@iki.fi>
	<2909559.M1IsAHpWSv@jar7.dominio>
	<CAOcJUbyt418Cg=5JawNq_U_4bUG+ztqB_7n7iOvwWgo-zvROhg@mail.gmail.com>
	<2616361.Xo6SKdVfQO@jar7.dominio>
	<510E645A.80103@iki.fi>
Date: Sun, 3 Feb 2013 14:27:16 -0500
Message-ID: <CAOcJUbxMBs=P8VJ_F50hXK+gxUuQ+kGYzD1yS9N7z48nDA-Ntw@mail.gmail.com>
Subject: Re: af9035 test needed!
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 3, 2013 at 8:21 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 02/03/2013 02:04 PM, Jose Alberto Reguero wrote:
>>
>> On Sábado, 2 de febrero de 2013 23:00:45 Michael Krufky escribió:
>>>
>>> On Fri, Jan 11, 2013 at 6:45 PM, Jose Alberto Reguero
>>>
>>> <jareguero@telefonica.net> wrote:
>>>>
>>>> On Viernes, 11 de enero de 2013 20:38:01 Antti Palosaari escribió:
>>>>>
>>>>> Hello Jose and Gianluca
>>>>>
>>>>> Could you test that (tda18218 & mxl5007t):
>>>>>
>>>>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/it9135_t
>>>>> une r
>>>>>
>>>>> I wonder if ADC config logic still works for superheterodyne tuners
>>>>> (tuner having IF). I changed it to adc / 2 always due to IT9135 tuner.
>>>>> That makes me wonder it possible breaks tuners having IF, as ADC was
>>>>> clocked just over 20MHz and if it is half then it is 10MHz. For BB that
>>>>> is enough, but I think that having IF, which is 4MHz at least for 8MHz
>>>>> BW it is too less.
>>>>>
>>>>> F*ck I hate to maintain driver without a hardware! Any idea where I can
>>>>> get AF9035 device having tda18218 or mxl5007t?
>>>>>
>>>>> regards
>>>>> Antti
>>>>
>>>>
>>>> Still pending the changes for  mxl5007t. Attached is a patch for that.
>>>>
>>>> Changes to make work Avermedia Twinstar with the af9035 driver.
>>>>
>>>> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
>>>>
>>>> Jose Alberto
>>>>
>>>> diff -upr linux/drivers/media/tuners/mxl5007t.c
>>>> linux.new/drivers/media/tuners/mxl5007t.c
>>>> --- linux/drivers/media/tuners/mxl5007t.c       2012-08-14
>>>> 05:45:22.000000000 +0200 +++ linux.new/drivers/media/tuners/mxl5007t.c
>>>> 2013-01-10 19:23:09.247556275 +0100
>>>> @@ -374,7 +374,6 @@ static struct reg_pair_t *mxl5007t_calc_
>>>>
>>>>          mxl5007t_set_if_freq_bits(state, cfg->if_freq_hz,
>>>> cfg->invert_if);
>>>>          mxl5007t_set_xtal_freq_bits(state, cfg->xtal_freq_hz);
>>>>
>>>> -       set_reg_bits(state->tab_init, 0x04, 0x01,
>>>> cfg->loop_thru_enable);
>>>>
>>>>          set_reg_bits(state->tab_init, 0x03, 0x08, cfg->clk_out_enable
>>>> <<
>>>>          3);
>>>>          set_reg_bits(state->tab_init, 0x03, 0x07, cfg->clk_out_amp);
>>>
>>>
>>> This is a configurable option - it should not be removed, just
>>> configure your glue code to not use that option if you dont want
>>> it.... unless there's some other reason why you're removing this?
>>>
>>
>> I just move the code to a mxl5007t_attach because with dual tuner until
>> the
>> code is executed, the other tuner don't work. It can be left here also.
>>
>>>> @@ -531,9 +530,12 @@ static int mxl5007t_tuner_init(struct mx
>>>>
>>>>          struct reg_pair_t *init_regs;
>>>>          int ret;
>>>>
>>>> -       ret = mxl5007t_soft_reset(state);
>>>> -       if (mxl_fail(ret))
>>>> +       if (!state->config->no_reset) {
>>>> +               ret = mxl5007t_soft_reset(state);
>>>> +               if (mxl_fail(ret))
>>>>
>>>>                  goto fail;
>>>>
>>>> +       }
>>>> +
>>>
>>>
>>> this seems wrong to me.  why would you want to prevent the driver from
>>> doing a soft reset?
>>>
>>
>> That is because with my hardware and dual tuner, when one tuner do reset,
>> the
>> other one is perturbed, and the stream has errors.
>>
>>>>          /* calculate initialization reg array */
>>>>          init_regs = mxl5007t_calc_init_regs(state, mode);
>>>>
>>>> @@ -887,7 +889,12 @@ struct dvb_frontend *mxl5007t_attach(str
>>>>
>>>>                  if (fe->ops.i2c_gate_ctrl)
>>>>
>>>>                          fe->ops.i2c_gate_ctrl(fe, 1);
>>>>
>>>> -               ret = mxl5007t_get_chip_id(state);
>>>> +               if (!state->config->no_probe)
>>>> +                       ret = mxl5007t_get_chip_id(state);
>>>> +
>>>> +               ret = mxl5007t_write_reg(state, 0x04,
>>>> +                       state->config->loop_thru_enable);
>>>> +
>>>
>>>
>>> Can you explain why this change was made?  ^^
>>>
>>
>> mxl5007t_get_chip_id has a read, and with the hardware I have, after the
>> read
>> operation is made, communication with the chip don't work.
>>
>>>>                  if (fe->ops.i2c_gate_ctrl)
>>>>
>>>>                          fe->ops.i2c_gate_ctrl(fe, 0);
>>>>
>>>> diff -upr linux/drivers/media/tuners/mxl5007t.h
>>>> linux.new/drivers/media/tuners/mxl5007t.h
>>>> --- linux/drivers/media/tuners/mxl5007t.h       2012-08-14
>>>> 05:45:22.000000000 +0200 +++ linux.new/drivers/media/tuners/mxl5007t.h
>>>> 2013-01-10 19:19:11.204379581 +0100
>>>> @@ -73,8 +73,10 @@ struct mxl5007t_config {
>>>>
>>>>          enum mxl5007t_xtal_freq xtal_freq_hz;
>>>>          enum mxl5007t_if_freq if_freq_hz;
>>>>          unsigned int invert_if:1;
>>>>
>>>> -       unsigned int loop_thru_enable:1;
>>>> +       unsigned int loop_thru_enable:3;
>>>
>>>
>>> Why widen this boolean to three bits?
>>>
>>
>> I just use the value 3 for this option(taken from windows driver) and it
>> works
>> well.
>>
>>
>> Thanks for review the code.
>>
>> Jose Alberto
>>
>>>>          unsigned int clk_out_enable:1;
>>>>
>>>> +       unsigned int no_probe:1;
>>>> +       unsigned int no_reset:1;
>>>>
>>>>   };
>>>>
>>>>   #if defined(CONFIG_MEDIA_TUNER_MXL5007T) ||
>>>>
>>>> (defined(CONFIG_MEDIA_TUNER_MXL5007T_MODULE) && defined(MODULE))
>>>> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c
>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
>>>> --- linux/drivers/media/usb/dvb-usb-v2/af9035.c 2013-01-07
>>>> 05:45:57.000000000 +0100
>>>> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c     2013-01-12
>>>> 00:30:57.557310465 +0100
>>>> @@ -886,13 +886,17 @@ static struct mxl5007t_config af9035_mxl
>>>>
>>>>                  .loop_thru_enable = 0,
>>>>                  .clk_out_enable = 0,
>>>>                  .clk_out_amp = MxL_CLKOUT_AMP_0_94V,
>>>>
>>>> +               .no_probe = 1,
>>>> +               .no_reset = 1,
>>>>
>>>>          }, {
>>>>
>>>>                  .xtal_freq_hz = MxL_XTAL_24_MHZ,
>>>>                  .if_freq_hz = MxL_IF_4_57_MHZ,
>>>>                  .invert_if = 0,
>>>>
>>>> -               .loop_thru_enable = 1,
>>>> +               .loop_thru_enable = 3,
>>>>
>>>>                  .clk_out_enable = 1,
>>>>                  .clk_out_amp = MxL_CLKOUT_AMP_0_94V,
>>>>
>>>> +               .no_probe = 1,
>>>> +               .no_reset = 1,
>>>>
>>>>          }
>>>>
>>>>   };
>>>
>>>
>>> This patch cannot be merged as-is.  I'm sorry.  If you could explain
>>> why each change was made, then perhaps I would be able to advise
>>> better how to make this work on your device without breaking others.
>>>
>>> -Mike Krufky
>
>
> Mike, Jose,
> I think there is multiple bugs - both existing and new ones added by Jose.
>
> First existing MxL5007t driver bugs, which are tried to resolve by Jose just
> wrongly.
>
> You configure clock output and RF loop-through only after first tune and
> during every tune.
>
> Control flow of mxl5007t init seems to be totally broken logically and
> cannot work if there is slave tuner used.
>
> Relevant control flow bug is that:
>
> mxl5007t_set_params() {
>   mxl5007t_tuner_init() {
>     mxl5007t_soft_reset()
>     -- configure clock output
>     -- configure RF loop-through
>   }
> }
>
> RF loop-through as well clock output should be configured on attach() that
> you could trust slave tuner is operational just after all is attached().
>
> Also, there is another bug, which likely causes disturbance to picture Jose
> mentioned. MxL5007t soft reset resets all registers to default state. You do
> that *every* time when set_params() is called. Could you guess what happens
> to clock output and RF loop-through slave tuner is using?
>
> I made month or two back patch series fixing similar problems of FC0012
> driver. See example from there. Jose's hacks are not mostly relevant after
> that MxL5007t driver is fixed to offer clock and loop-through correctly to
> the slave tuner.
>
> ************************
>
> Another issue is that register 04, which contains loop-though and some other
> bits. Jose changes its value from 1 to 3. Is that change really needed? What
> happens if you leave it just 1? You should not change options like that just
> for fun without need.
>
>
> regards
> Antti


Due to the complexity of the situation, I would ask that the changes
against mxl5007t be resubmitted as a patch series, where each patch
only makes a single change, and each patch description should describe
that change and the reason for why it is being made.  (this should be
the gold standard for all patches, anyway)

I don't mean to make things complicated, its just that the patch in
question seems to make many changes all at once and lacks clarity for
the reasons why those changes are being made.

Please break this up into a patch series of smaller changer so that we
can analyze each change separately, we will merge those which do not
cause issues with other hardware right away, leaving only the bits
that need further discussion unmerged.

Consider the loop thru change from 1 to 3 NACK'd for now, until a
better explanation can be provided.  Please leave that off the series
unless it is absolutely necessary, or you can provide better
documentation of it.

Best regards,

Mike Krufky
