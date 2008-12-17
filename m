Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1LCo5p-0005oT-9z
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 05:33:06 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1562261fga.25
	for <linux-dvb@linuxtv.org>; Tue, 16 Dec 2008 20:33:01 -0800 (PST)
Message-ID: <37219a840812162033m1462dd9doca52addaaf563de5@mail.gmail.com>
Date: Tue, 16 Dec 2008 23:33:01 -0500
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0812162029v78e10fc5u926e52e807263981@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0812161931r17fc2371mfcb28306a3acc610@mail.gmail.com>
	<37219a840812162006h33118a2fr109638bb0802603@mail.gmail.com>
	<37219a840812162022g4c53d521v19a74ccf97a50ef9@mail.gmail.com>
	<412bdbff0812162029v78e10fc5u926e52e807263981@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] RFC - xc5000 init_fw option is broken for HVR-950q
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

On Tue, Dec 16, 2008 at 11:29 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Tue, Dec 16, 2008 at 11:22 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> On Tue, Dec 16, 2008 at 11:06 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>>> Devin,
>>>
>>> On Tue, Dec 16, 2008 at 10:31 PM, Devin Heitmueller
>>> <devin.heitmueller@gmail.com> wrote:
>>>> It looks like because the reset callback is set *after* the
>>>> dvb_attach(xc5000...), the if the init_fw option is set the firmware
>>>> load will fail (saying "xc5000: no tuner reset callback function,
>>>> fatal")
>>>>
>>>> We need to be setting the callback *before* the dvb_attach() to handle
>>>> this case.
>>>>
>>>> Let me know if anybody sees anything wrong with this proposed patch,
>>>> otherwise I will submit a pull request.
>>>>
>>>> Thanks,
>>>>
>>>> Devin
>>>>
>>>> diff -r 95d2c94ec371 linux/drivers/media/video/au0828/au0828-dvb.c
>>>> --- a/linux/drivers/media/video/au0828/au0828-dvb.c     Tue Dec 16
>>>> 21:35:23 2008 -0500
>>>> +++ b/linux/drivers/media/video/au0828/au0828-dvb.c     Tue Dec 16
>>>> 22:27:57 2008 -0500
>>>> @@ -382,6 +382,9 @@
>>>>
>>>>        dprintk(1, "%s()\n", __func__);
>>>>
>>>> +       /* define general-purpose callback pointer */
>>>> +       dvb->frontend->callback = au0828_tuner_callback;
>>>> +
>>>>        /* init frontend */
>>>>        switch (dev->board) {
>>>>        case AU0828_BOARD_HAUPPAUGE_HVR850:
>>>> @@ -431,8 +434,6 @@
>>>>                       __func__);
>>>>                return -1;
>>>>        }
>>>> -       /* define general-purpose callback pointer */
>>>> -       dvb->frontend->callback = au0828_tuner_callback;
>>>>
>>>>        /* register everything */
>>>>
>>>> --
>>>> Devin J. Heitmueller
>>>> http://www.devinheitmueller.com
>>>> AIM: devinheitmueller
>>>
>>
>> Devin and I  (mostly Devin, actually) just realized that
>> "dvb->frontend = NULL until after the demod is attached.  The line
>> needs to be between the two dvb_attach() calls."
>>
>> So, I think we should leave the callback assignment where it is, and
>> just get rid of the init_fw parameter for the xc5000 driver.
>>
>> I added this init_fw option in the first place, and we really dont
>> need it there anymore.
>>
>> -Mike
>>
>
> Updated patch attached which removes the init_fw option entirely.
>
> Devin
>

Agreed.

Acked-by: Michael Krufky <mkrufky@linuxtv.org>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
