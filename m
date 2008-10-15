Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1Kq7Xq-0002iJ-Az
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 16:40:15 +0200
Received: by ey-out-2122.google.com with SMTP id 25so972519eya.17
	for <linux-dvb@linuxtv.org>; Wed, 15 Oct 2008 07:40:09 -0700 (PDT)
Message-ID: <412bdbff0810150740h61049f5fvb679bdebbcd4084d@mail.gmail.com>
Date: Wed, 15 Oct 2008 10:40:09 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48F5FE80.5010106@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0810150724h2ab46767ib7cfa52e3fdbc5fa@mail.gmail.com>
	<48F5FE80.5010106@linuxtv.org>
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

On Wed, Oct 15, 2008 at 10:30 AM, Steven Toth <stoth@linuxtv.org> wrote:
> The SNR units should be standardized into a single metric, something
> actually useful like ESNO or db. If that isn't available then we should aim
> to eyeball / manually calibrate impossible boards against known reliable
> demods on the same feed, it should be close enough.
>
> This requires patience and time from the right people with the right
> hardware.

I agree that standardizing on a particular unit would be the ideal
scenario.  Realistically though, do you have any confidence that this
would actually happen?  Many frontends would have to change, reverse
engineering would have to be done, and in many cases without a signal
generator this would be very difficult.  This could take months or
years, or might never happen.

Certainly I'm in favor of expressing that there is a preferred unit
that new frontends should use (whether that be ESNO or db), but the
solution I'm suggesting would allow the field to become useful *now*.
This would hold us over until all the other frontends are converted to
db (which I have doubts will ever actually happen).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
