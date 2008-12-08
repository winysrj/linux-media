Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1L9nDr-0007nh-15
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 22:00:55 +0100
Received: by ey-out-2122.google.com with SMTP id 25so598601eya.17
	for <linux-dvb@linuxtv.org>; Mon, 08 Dec 2008 13:00:51 -0800 (PST)
Message-ID: <493D8B00.2030600@googlemail.com>
Date: Mon, 08 Dec 2008 22:00:48 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <492168D8.4050900@googlemail.com>	
	<c74595dc0812020849p4d779677ge468871489e7d44@mail.gmail.com>	
	<49358FE8.9020701@googlemail.com>	
	<c74595dc0812021205x22936540w9ce74549f07339ff@mail.gmail.com>	
	<4935B1B3.40709@googlemail.com>	
	<c74595dc0812022323w1df844cegc0c0ef269babed66@mail.gmail.com>	
	<4936BE27.10800@googlemail.com>	
	<9ac6f40e0812031104q1b3a419ub5c1a58d19f96239@mail.gmail.com>	
	<c74595dc0812031328i32bc9997t632e0f63a8849b03@mail.gmail.com>	
	<493D81DF.4010601@googlemail.com>
	<c74595dc0812081236v4917e57fq7afc854cd63c4dc4@mail.gmail.com>
In-Reply-To: <c74595dc0812081236v4917e57fq7afc854cd63c4dc4@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH]Fix a bug in scan,
 which outputs the wrong frequency if the current tuned transponder
 is scanned only
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

Alex Betis schrieb:
> All the tuned parameters are read from the frontend, the problem is that the
> frontend returns the values that were used to tune, not the real tuned
> values, so if tuning was done with QAM_AUTO, scan-s2 output will not include
> modulation since frontend returned QAM_AUTO.

The parameters are read from property cache and not from frontend. I've add a second ioctl
call for FE_GET_FRONTEND. This will read the real modulation type.

Regards,
Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
