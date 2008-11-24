Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAO4UYWe031695
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 23:30:34 -0500
Received: from smtp131.rog.mail.re2.yahoo.com (smtp131.rog.mail.re2.yahoo.com
	[206.190.53.36])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAO4UIYl018732
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 23:30:18 -0500
Message-ID: <492A2DD9.7090500@rogers.com>
Date: Sun, 23 Nov 2008 23:30:17 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: "daniel.perzynski" <daniel.perzynski@aster.pl>
References: <6367380D4484A05418484321130E6EE212273045156E0FF6E4617EF3586D@webmail.aster.pl>
In-Reply-To: <6367380D4484A05418484321130E6EE212273045156E0FF6E4617EF3586D@webmail.aster.pl>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: Avermedia A312 wiki page
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

daniel.perzynski wrote:
> CityK wrote:
>> This thing (mini pci card) has an usb interface?  Strange.
> What is concerning mini pci having usb interface I can say only that on
> Avermedia webpage that card is in Mini PCI & Mini Card category.
>   

On quick glance the "Mini PCI" part threw me off ... but it is indeed of
the later category instead: a PCIe Mini Card
(http://en.wikipedia.org/wiki/PCI_Express_Mini_Card)


daniel.perzynski wrote:
> I've updated Avermedia A312 wiki page. Here is the link:
> http://www.linuxtv.org/wiki/index.php/AVerMedia_A312_%28ATSC%29
>   

thanks

> Can someone please provide me with the information which kernel modules
> I should try to load to proceed further with checking if card can be supported?

you're going to need:

- the Xceive XC3028 driver and firmware ... see the wiki
(http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028), in
particular about the necessary code requirements for the IC and related
bridge

- the lgdt330x module ... there is also a lgdt3304 module, which I
believe was recently submitted ... I'm not sure why there are two
modules, as I believe the original lgdt330x is capable of handling the
3304 ... perhaps the second, more recent, is something specific to one
of mrec's projects.

- cxusb looks to be appropriate for this device ... I'm not sure whether
or not this will require something like the bluebird firmware as well,
someone else will have to comment ...  not sure whether analog support
(through the cx25843) has been realized for either (e.g. the DViCO
FusionHDTV5 USB Gold for example)

- have no idea what module for the Wolfson audio IC ... I know Hans was
doing some conversion of drivers (in regards to i2c handling IIRC) and
this may or may not have been affected

Overall, the device looks to be a strong candidate for obtaining support
... however, how much of a pain in the butt that will turn out to be is
another matter altogether :)




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
