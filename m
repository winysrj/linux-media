Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from thouse03.taonet.it ([195.32.96.103])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <steven.dorigotti@tvblob.com>) id 1K8Ajv-0003oh-Qk
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 11:11:18 +0200
Message-Id: <1EA8EF72-E246-4F1F-8320-94EF39520C49@tvblob.com>
From: Steven Dorigotti <steven.dorigotti@tvblob.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <873CB0CE-12F6-4967-9E2A-697CFBAD425F@tvblob.com>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Mon, 16 Jun 2008 11:09:53 +0200
References: <873CB0CE-12F6-4967-9E2A-697CFBAD425F@tvblob.com>
Subject: Re: [linux-dvb] opening dvr for writing
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0980473313=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0980473313==
Content-Type: multipart/alternative; boundary=Apple-Mail-8--923007318


--Apple-Mail-8--923007318
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit


Thankyou for the reply, but the original test (in linuxtv-dvb- 
apps-1.1.1.tar.gz) was run with O_WRONLY and I still got "Invalid  
argument".

Has anyone else had problems opening DVR for writing? (test case shown  
below).

thanks,
Steven

>> The only 2 supported modes are O_RDONLY and O_WRONLY.
>> in dmxdev.c around line 160.
>
> sorry...
>
> ... unless the device has the capability DMXDEV_CAP_DUPLEX which I  
> can't really see what it is.
>>
>>> Hello,
>>>
>>>   I am trying to write data to the dvr device in order to playback
>>> recorded streams back on the frontend device for testing purposes.
>>>
>>>   I have tried the following test taken from linuxtv-dvb-
>>> apps-1.1.1.tar.gz (as well as others):
>>>
>>> # ./test_dvr_play ../james.mpg 33 34
>>> Playing '../james.mpg', video PID 0x0021, audio PID 0x0022
>>> Failed to open '/dev/dvb/adapter0/dvr0': 22 Invalid argument
>>>
>>> both on mips (custom) and x86 (Ubuntu Etch) architectures with the
>>> following hardware: DiB0070 and wt220u.
>>>
>>>   If the open() mode is changed to RDWR instead of WRONLY, errno
>>> changes to "Operation not supported".
>>>
>>>   Is this a known bug and is there a patch available? I have done
>>> similar tests with a much older version of linux-dvb in the past  
>>> with
>>> no problems.
>>>
>>> cheers,
>>> Steven
>>>
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>

--Apple-Mail-8--923007318
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div><br></div><div><blockquote =
type=3D"cite"></blockquote>Thankyou for the reply, but the original test =
(in&nbsp;linuxtv-dvb-apps-1.1.1.tar.gz) was run with O_WRONLY and I =
still got "Invalid argument".&nbsp;</div><div><br></div><div>Has anyone =
else had problems opening DVR for writing? (test case shown =
below).</div><div><br></div><div>thanks,</div><div>Steven</div><div><br><b=
lockquote type=3D"cite"><blockquote type=3D"cite">The only 2 supported =
modes are O_RDONLY and O_WRONLY.<br></blockquote><blockquote =
type=3D"cite">in dmxdev.c around line =
160.<br></blockquote><br>sorry...<br><br>... unless the device has the =
capability DMXDEV_CAP_DUPLEX which I can't really see what it =
is.</blockquote></div><blockquote type=3D"cite"><blockquote =
type=3D"cite"><div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite"><div>Hello,<br><br> &nbsp;&nbsp;I am trying to write data =
to the dvr device in order to playback &nbsp;<br>recorded streams back =
on the frontend device for testing purposes.<br><br> &nbsp;&nbsp;I have =
tried the following test taken from linuxtv-dvb- <br>apps-1.1.1.tar.gz =
(as well as others):<br><br># ./test_dvr_play ../james.mpg 33 =
34<br>Playing '../james.mpg', video PID 0x0021, audio PID =
0x0022<br>Failed to open '/dev/dvb/adapter0/dvr0': 22 Invalid =
argument<br><br>both on mips (custom) and x86 (Ubuntu Etch) =
architectures with the &nbsp;<br>following hardware: DiB0070 and =
wt220u.<br><br> &nbsp;&nbsp;If the open() mode is changed to RDWR =
instead of WRONLY, errno &nbsp;<br>changes to "Operation not =
supported".<br><br> &nbsp;&nbsp;Is this a known bug and is there a patch =
available? I have done &nbsp;<br>similar tests with a much older version =
of linux-dvb in the past with &nbsp;<br>no =
problems.<br><br>cheers,<br>Steven<br><br><br>____________________________=
___________________<br>linux-dvb mailing list<br><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br><br></div></bloc=
kquote></div><br></blockquote></blockquote></body></html>=

--Apple-Mail-8--923007318--



--===============0980473313==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0980473313==--
