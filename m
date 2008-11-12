Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1L0Mzf-0007PY-R2
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 22:11:21 +0100
From: Darron Broad <darron@kewl.org>
To: "Alex Betis" <alex.betis@gmail.com>
In-reply-to: <c74595dc0811121304o44e4270am67173ed5857f6945@mail.gmail.com> 
References: <c74595dc0811121232s48a95a14v93edf27360ed5c21@mail.gmail.com>
	<30422.1226523269@kewl.org>
	<c74595dc0811121304o44e4270am67173ed5857f6945@mail.gmail.com>
Date: Wed, 12 Nov 2008 21:11:16 +0000
Message-ID: <30603.1226524276@kewl.org>
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] S2API tune return code - potential problem?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <c74595dc0811121304o44e4270am67173ed5857f6945@mail.gmail.com>, "Alex Betis" wrote:
>On Wed, Nov 12, 2008 at 10:54 PM, Darron Broad <darron@kewl.org> wrote:
>
>> In message <c74595dc0811121232s48a95a14v93edf27360ed5c21@mail.gmail.com>,
>> "Alex Betis" wrote:
>> >
>> >Hi All,
>>
>> Hi.
>>
>> >A question regarding the error code returned from the driver when using
>> >DTV_TUNE property.
>> >Following the code I came to dvb_frontend_ioctl_legacy function and
>> reached
>> >the FE_SET_FRONTEND case.
>> >Looking on the logic I couldn't see any handling of error tuning, an event
>> >is added to the frontend and zero is returned:
>> >
>> >        fepriv->state = FESTATE_RETUNE;
>> >        dvb_frontend_wakeup(fe);
>> >        dvb_frontend_add_event(fe, 0);
>> >        fepriv->status = 0;
>> >        err = 0;
>> >        break;
>> >
>> >How should an application know that DTV_TUNE command succeed?
>> >Monitoring the LOCK bit is not good, here's an example why I ask the
>> >question:
>> >
>> >Assuming the cx24116 driver is locked on a channel. Application sends tune
>> >command to another channel while specifying
>> >AUTO settings for modulation and FEC. The driver for that chip cant handle
>> >AUTO settings and return error, while its still connected
>> >to previous channel. So in that case LOCK bit will be ON, while the tune
>> >command was ignored.
>> >
>> >I thought of an workaround to query the driver for locked frequency and
>> >check whenever its in bounds of frequency that was ordered
>> >to be tuned + - some delta, but that's a very dirty solution.
>> >
>> >Any thoughts? Or I'm missing something?
>>
>> Correct me if I am wrong, but I remember looking at this before...
>>
>> The problem is that no capabilities are available for S2API demods as yet
>> so TUNE always succeeds whether the parameters are wrong or right.
>>
>> What is needed is:
>> 1. caps for s2api aware demods.
>> 2. extend dvb_frontend_check_parameters() for s2api aware demods.
>>
>You mean passing the parameter to the demods to be checked before performing
>the tuning?

Not entirely, I mean more that they expose their caps. This isn't available as yet.

>Is there an example of that usage?

No.

>What about some unexpected failures that can't be checked before the tuning?

I am only thinking about the legitimacy of the parameters not whether
they work or not.

>Can't think of a real example since I'm not too familiar with
>the code.

Okay.

>I thought about a property of "last error code" that can be queried from the
>driver, but in that case the application has to be aware when
>the tuning is finished.

Tuning actually occurs in the frontend thread. The frontend status
tells you if it worked or not but not whether the parameters were
wrong. I agree that perhaps broken parameters could de-tune, but
there are not enough rules for s2api as yet to know how to proceed.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
