Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 17 Oct 2008 14:23:10 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48F89D48.70207@linuxtv.org>
To: Andreas Oberritter <obi@linuxtv.org>
Message-id: <48F8D80E.6020909@linuxtv.org>
MIME-version: 1.0
References: <412bdbff0810150724h2ab46767ib7cfa52e3fdbc5fa@mail.gmail.com>
	<48F5FE80.5010106@linuxtv.org>
	<412bdbff0810150740h61049f5fvb679bdebbcd4084d@mail.gmail.com>
	<48F633FA.4000106@linuxtv.org> <48F86120.2020203@linuxtv.org>
	<48F893A3.4060607@linuxtv.org> <48F89D48.70207@linuxtv.org>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Revisiting the SNR/Strength issue
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

Andreas Oberritter wrote:
> Steven Toth wrote:
>> I don't agree to blindly massaging the demod values and trying to add a
>> fake user facing API is a real solution.
> 
> I wonder what you're referring to with this sentence.

I think trying to massage various mysterious and unknown demod 
statistics into something that we can barely understand, in order to get 
them exposed in either a single unit of measure, or multiple units of 
measure, isn't a credible solution.

We should go back and find the correct SNR mechanism for each demod. 
Then review and agree on an internal kernel spec, and re-engineer the 
demods to meet the spec.

Devin has started the ball rolling nicely, to allow this to happen.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
