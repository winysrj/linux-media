Return-path: <linux-media-owner@vger.kernel.org>
Received: from anny.lostinspace.de ([80.190.182.2]:52155 "EHLO
	anny.lostinspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbZKVU0W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 15:26:22 -0500
Message-ID: <4B099E37.5070405@fechner.net>
Date: Sun, 22 Nov 2009 21:25:27 +0100
From: Matthias Fechner <idefix@fechner.net>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: linux-media@vger.kernel.org, Jarod Wilson <jarod@wilsonet.com>,
	Jean Delvare <khali@linux-fr.org>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: Re: IR Receiver on an Tevii S470
References: <4B0459B1.50600@fechner.net> <4B081F0B.1060204@fechner.net>	 <1258836102.1794.7.camel@localhost>  <200911220303.36715.liplianin@me.by>	 <1258858102.3072.14.camel@palomino.walls.org>  <4B097E37.10402@fechner.net> <1258920707.4201.16.camel@palomino.walls.org>
In-Reply-To: <1258920707.4201.16.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Andy Walls wrote:
>
> # modprobe cx23885
> # modprobe i2c-dev
> # i2c-detect -l
> (to list all the i2c buses, including cx23885 mastered i2c buses)
>   
i2c-0    smbus         SMBus nForce2 adapter at 4d00       SMBus adapter
i2c-1    i2c           cx23885[0]                          I2C adapter
i2c-2    i2c           cx23885[0]                          I2C adapter
i2c-3    i2c           cx23885[0]                          I2C adapter
i2c-4    i2c           NVIDIA i2c adapter                  I2C adapter
i2c-5    i2c           NVIDIA i2c adapter                  I2C adapter
i2c-6    i2c           NVIDIA i2c adapter                  I2C adapter

> # i2c-detect -y N
> (to show the addresses in use on bus # N: only query the cx23885 buses)
>
>   
vdrhd1 ~ # i2cdetect -y 1
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --                        
vdrhd1 ~ # i2cdetect -y 2
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
60: -- -- -- -- -- -- -- -- 68 -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --                        
vdrhd1 ~ # i2cdetect -y 3
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
40: -- -- -- -- 44 -- -- -- -- -- -- -- 4c -- -- --
50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --                        

> i2c-detect was in the lm-sensors package last I checked.  (Jean can
> correct me if I'm wrong.)
>
>   
ok, it seems that the name of tool is different here, but I think it has 
the same output.

> Then we can work out how to read and decode it's data and add it to
> ir-kbd-i2c at least.  Depending on how your kernel and LIRC versions
> LIRC might still work with I2C IR chips too.
>
>   
I will do my best to help you here.

Bye,
Matthias

-- 
"Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the universe trying to produce bigger and better idiots. So far, the universe is winning." -- Rich Cook

