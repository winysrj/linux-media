Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1L0MjR-0004z9-Pv
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 21:54:35 +0100
From: Darron Broad <darron@kewl.org>
To: "Alex Betis" <alex.betis@gmail.com>
In-reply-to: <c74595dc0811121232s48a95a14v93edf27360ed5c21@mail.gmail.com> 
References: <c74595dc0811121232s48a95a14v93edf27360ed5c21@mail.gmail.com>
Date: Wed, 12 Nov 2008 20:54:29 +0000
Message-ID: <30422.1226523269@kewl.org>
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

In message <c74595dc0811121232s48a95a14v93edf27360ed5c21@mail.gmail.com>, "Alex Betis" wrote:
>
>Hi All,

Hi.

>A question regarding the error code returned from the driver when using
>DTV_TUNE property.
>Following the code I came to dvb_frontend_ioctl_legacy function and reached
>the FE_SET_FRONTEND case.
>Looking on the logic I couldn't see any handling of error tuning, an event
>is added to the frontend and zero is returned:
>
>        fepriv->state = FESTATE_RETUNE;
>        dvb_frontend_wakeup(fe);
>        dvb_frontend_add_event(fe, 0);
>        fepriv->status = 0;
>        err = 0;
>        break;
>
>How should an application know that DTV_TUNE command succeed?
>Monitoring the LOCK bit is not good, here's an example why I ask the
>question:
>
>Assuming the cx24116 driver is locked on a channel. Application sends tune
>command to another channel while specifying
>AUTO settings for modulation and FEC. The driver for that chip cant handle
>AUTO settings and return error, while its still connected
>to previous channel. So in that case LOCK bit will be ON, while the tune
>command was ignored.
>
>I thought of an workaround to query the driver for locked frequency and
>check whenever its in bounds of frequency that was ordered
>to be tuned + - some delta, but that's a very dirty solution.
>
>Any thoughts? Or I'm missing something?

Correct me if I am wrong, but I remember looking at this before...

The problem is that no capabilities are available for S2API demods as yet
so TUNE always succeeds whether the parameters are wrong or right.

What is needed is:
1. caps for s2api aware demods.
2. extend dvb_frontend_check_parameters() for s2api aware demods.

This hasn't been done as yet.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
