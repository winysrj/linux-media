Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JQjEG-0000A2-My
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 14:06:48 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1016785fge.25
	for <linux-dvb@linuxtv.org>; Sun, 17 Feb 2008 05:06:48 -0800 (PST)
Message-ID: <ea4209750802170506o55b8b751u5c189f15bd140f44@mail.gmail.com>
Date: Sun, 17 Feb 2008 14:06:48 +0100
From: "Albert Comerma" <albert.comerma@gmail.com>
To: hfvogt@gmx.net
In-Reply-To: <ea4209750802170414n6e4f82dam4c6908536b695033@mail.gmail.com>
MIME-Version: 1.0
References: <200802112223.11129.hfvogt@gmx.net>
	<ea4209750802160638k387fba4dtd422f250fa79be7d@mail.gmail.com>
	<ea4209750802160842w28bfcd45m99308f38997c7a7a@mail.gmail.com>
	<200802162226.27645.hfvogt@gmx.net>
	<ea4209750802170414n6e4f82dam4c6908536b695033@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1091827855=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1091827855==
Content-Type: multipart/alternative;
	boundary="----=_Part_19379_3883740.1203253608412"

------=_Part_19379_3883740.1203253608412
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I got it!!!! I remembered that on PCTV DVB-T 72e they had a similar problem,
which was solved leaving GPIO6 to 0. Doing this the tuning seems to work
fine. SNR is always reported as 0% but I think this is not a problem, now I
can scan and tune dvb-t channels. Firmware is 1.10 and xc3028-v27 with that
modification. Thanks a lot for your help. Next step would be analog.

Albert

------=_Part_19379_3883740.1203253608412
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I got it!!!! I remembered that on PCTV DVB-T 72e they had a similar problem, which was solved leaving GPIO6 to 0. Doing this the tuning seems to work fine. SNR is always reported as 0% but I think this is not a problem, now I can scan and tune dvb-t channels. Firmware is 1.10 and xc3028-v27 with that modification. Thanks a lot for your help. Next step would be analog.<br>
<br>Albert<br>

------=_Part_19379_3883740.1203253608412--


--===============1091827855==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1091827855==--
