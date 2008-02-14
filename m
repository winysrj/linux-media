Return-path: <linux-dvb-bounces@linuxtv.org>
Message-ID: <47B4ADDD.5070700@kaiser-linux.li>
Date: Thu, 14 Feb 2008 22:08:45 +0100
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <47B4A69F.9020009@kaiser-linux.li>
	<37219a840802141254y12375e4dxd0e61cec97f8dc1a@mail.gmail.com>
In-Reply-To: <37219a840802141254y12375e4dxd0e61cec97f8dc1a@mail.gmail.com>
Cc: _LinuxTV-DVB - Mailinglist <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [OT] request_firmware()
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Michael Krufky wrote:
> On Thu, Feb 14, 2008 at 3:37 PM, Thomas Kaiser
> <linux-dvb@kaiser-linux.li> wrote:
>> Hello
>>
>>  I know this is the wrong list to ask, but you use this function (see subject)
>>  and I think somebody can answer my question.
>>
>>  Why does request_firmware need a device as parameter?
>>  int request_firmware(const struct firmware **fw, const char *name,
>>                      struct device *device);
>>
>>  I thought request_firmware just loads the firmware in the struct firmware?
> 
> 
> IIRC, when the device is destroyed, it is a signal for the memory used
> to store the firmware to be freed if not done already.
> 
> -Mike

So, that means when the pointer to device gets null the memory which holds the 
firmware is freed?

Thanks,

Thomas


-- 
http://www.kaiser-linux.li

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
