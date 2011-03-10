Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <simon@koala.ie>) id 1PxbKn-0005mr-RI
	for linux-dvb@linuxtv.org; Thu, 10 Mar 2011 09:35:02 +0100
Received: from [195.7.61.12] (helo=killala.koala.ie)
	by mail.tu-berlin.de (exim-4.74/mailfrontend-b) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1PxbKn-0006RZ-77; Thu, 10 Mar 2011 09:35:01 +0100
Received: from [195.7.61.12] (killala.koala.ie [195.7.61.12])
	(authenticated bits=0)
	by killala.koala.ie (8.14.4/8.13.7) with ESMTP id p2A8YtSc005716
	for <linux-dvb@linuxtv.org>; Thu, 10 Mar 2011 08:34:56 GMT
Message-ID: <4D788D2F.40803@koala.ie>
Date: Thu, 10 Mar 2011 08:34:55 +0000
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <DB7182D0-F83D-459A-8706-40E67D0ABD06@googlemail.com>
In-Reply-To: <DB7182D0-F83D-459A-8706-40E67D0ABD06@googlemail.com>
Subject: Re: [linux-dvb] Simultaneous recordings from one frontend
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

On 09/03/2011 13:41, Pascal J=FCrgens wrote:
> Hi all,
>
> SUMMARY: What's the best available tool for demultiplexing into multiple
> simultaneous recordings (files)?
>
> I'm looking for a way to record a TS to overlapping files (ie, files2
> should start 5 minutes before file1 ends). This means that two readers
> need to access the card at once. As far as I can tell from past
> discussions [1], this is not a feature that's currently present or
> planned in the kernel.
mythtv
-- =

simon

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
