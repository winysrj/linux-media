Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48F8FC70.6070904@linuxtv.org>
Date: Fri, 17 Oct 2008 16:58:24 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Felix Kolotinsky <Felix.Kolotinsky@avermedia.com>
References: <53F810EF6C2171468FEBEE7B91F672DF0DF8F7@USEXV01.avermediausa.com>
In-Reply-To: <53F810EF6C2171468FEBEE7B91F672DF0DF8F7@USEXV01.avermediausa.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Initial support for AVerTVHD Volar
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

Felix Kolotinsky wrote:
>
> Hi Daniel and Mike
>
>  
>
> My name is Felix Kolotinsky and I am product manager at AVerMeia Tech 
> USA office and I am in Bay area too.
>

Hello, Felix.

>  
>
> I came across your posting for AVerTVHD Volar A868 and sound like you 
> were able to get this tuner to work in Linux and  I would like to get 
> more info from you:
>
> 1.       What kernel did you use
>

We merged support for the device into kernel 2.6.27

> 2.       What Linux flavor is it
>

We merged support for the device into the official vanilla kernel 
2.6.27, which means that all distributions based on 2.6.27 or later will 
have support.

> 3.       What application
>

Support was added to the dvb-usb-cxusb driver, which uses the linux-dvb 
standard API.  Any linux-dvb standard compliant application will work 
with the device.

> 4.       How is performance of this tuner?
>
As I understand it, not very good.  I helped Daniel merge the code, but 
I don't have one of these devices of my own -- if you'd like to send me 
one, I can test it out myself and make improvements as necessary.  We 
suspect that the issue lies in driver for the MaxLinear tuner.

If you want to send me a device, please email me privately off-list and 
I'll give you a mailing address.

> 5.       And some other questions J
>
>  
>
> I have a few questions to you about your post for AVerTVHD Volar with 
> Linux.
>
> Would you please let get back to me either by email or call me at my 
> cell below.
>

I'm a bit busy right now -- lets keep it on email.  If this is a private 
matter, please feel free to email me privately off-list.  mkrufky at 
linuxtv dot org

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
