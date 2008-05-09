Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ppp196-18.static.internode.on.net ([59.167.196.18]
	helo=jumpgate.rods.id.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Rod@Rods.id.au>) id 1Jud60-0001ck-18
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 02:37:54 +0200
Received: from jumpgate.rods.id.au (localhost [127.0.0.1])
	by jumpgate.rods.id.au (Postfix) with ESMTP id 22A375BAE22
	for <linux-dvb@linuxtv.org>; Sat, 10 May 2008 09:58:53 +1000 (EST)
Received: from [192.168.3.44] (shadow.rods.id.au [192.168.3.44])
	by jumpgate.rods.id.au (Postfix) with ESMTP id 0B8EB5BAE20
	for <linux-dvb@linuxtv.org>; Sat, 10 May 2008 09:58:53 +1000 (EST)
Message-ID: <4824E53D.7040103@Rods.id.au>
Date: Sat, 10 May 2008 09:58:53 +1000
From: Rod <Rod@Rods.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------040608080109050804080200"
Subject: [linux-dvb] [Fwd: Re: Try to Make DVB-T part of Compro VideoMate
 T750 Work]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------040608080109050804080200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------040608080109050804080200
Content-Type: message/rfc822;
 name="Re: [linux-dvb] Try to Make DVB-T part of Compro VideoMate T750      Work.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="Re: [linux-dvb] Try to Make DVB-T part of Compro VideoMate T";
 filename*1="750      Work.eml"

Received: from 58.105.235.135.optusnet.com.au ([58.105.235.135])
        (SquirrelMail authenticated user yendor)
        by www.rods.id.au with HTTP;
        Fri, 9 May 2008 09:31:16 +1000 (EST)
Message-ID: <3720.58.105.235.135.1210289476.squirrel@www.rods.id.au>
In-Reply-To: <200805082332.45491.b87605214@ntu.edu.tw>
References: <200805071307.15982.b87605214@ntu.edu.tw>
    <48231231.7040905@Rods.id.au>
    <200805082332.45491.b87605214@ntu.edu.tw>
Date: Fri, 9 May 2008 09:31:16 +1000 (EST)
Subject: Re: [linux-dvb] Try to Make DVB-T part of Compro VideoMate T750
     Work
From: "Rod Smart" <Rod@Rods.id.au>
To: "lin" <b87605214@ntu.edu.tw>
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
X-Priority: 3 (Normal)
Importance: Normal
Content-Transfer-Encoding: quoted-printable


> On 2008 May 8 Thursday 22:46:09 Rod wrote:
>>     Hi, is there anyone actually working on this?
>>
>>     I cannot program for the life of me (for now) si, I'd like some
>> assistance?
>>
>>     I can get the SAA to be seen on the I2C bus, and a scan doesn't
>> reveal the true addresses of the chips behind it (along with the
>> previously seen reports of the addresses of the devices.
>>
>>     I have manually probed and have obtained the actual I2C addressing
>> of most of the chips (except for the XC device, BGA's are difficult, a=
nd
>> the PRO1A, well I havn't gone to the length of X-ray'ing it yet, but
>> maybe I'll have to give that a go (X-ray to get the die information,
>> then try and resolve its function from that info) or I'll just power t=
he
>> device and see what it does.. wish i still had the "Pinpoint" system a=
t
>> my disposal.
>>
>>     So, I'm looking for help, or a group to chat with to try and help
>> this little device along ;o)
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> Hi, Rod:
>
> I'm just a little owner of T750, and not a electrical circuit expert. I
> just
> can read some code of kernel drivers. I do definitly want to give you a
> hand
> and make this cards work over v4l, but what can I do for you? I live in
> Taiwan, if it necessary and Compro wants to tell me, I can give Compro =
a
> call
> and ask some questions which may keep this branch forward.
>
> 2008/05/08
> linleno
>

Hi Linleno

I have the I2C ports that each device sits on (except the XC device) that
i probed from the board, I have the interconnections between the SAA and
the 6353 device, and I think (couldn't find/forgot) the QT1010 is
connected to the 6353 Secondary I2C port for tuning control.

The Reset line on the '6353 is tied to a RC network, with an option to be
controlled from the SAA device, this link can be added at another time.

I'd also like to be able to control the RTC on the board so I can restart
the computer at a certain time, the Linux drivers for controlling my mobo
don't work, and screw the BIOS ;o(


--=20
Qn. Whats the differance between a Snake and a Onion?

Ans. No one cries when you chop up a Snake
  (SOLS - Snake Tales)

--------------040608080109050804080200
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040608080109050804080200--
