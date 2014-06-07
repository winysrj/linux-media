Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-hk1lp0126.outbound.protection.outlook.com ([207.46.51.126]:32960
	"EHLO APAC01-HK1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbaFGCEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 22:04:20 -0400
From: James Harper <james@ejbdigital.com.au>
To: =?iso-8859-1?Q?Ren=E9?= <poisson.rene@neuf.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: fusion hdtv dual express 2
Date: Sat, 7 Jun 2014 02:04:11 +0000
Message-ID: <0a5548fd6c404008bb16a6aaf36e551e@SIXPR04MB304.apcprd04.prod.outlook.com>
References: <262b1efa828c406c82691ee6b5a34656@SIXPR04MB304.apcprd04.prod.outlook.com>
 <499085CD3245488F996F556AFD77977C@ci5fish>
In-Reply-To: <499085CD3245488F996F556AFD77977C@ci5fish>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi James,
> 
> The first basic thing you should look at is if the dvb device has got all
> its pieces.
> A dvb adapter has, sort of, 4 sub-devices:
> [me@home ~]$ ll /dev/dvb/adapter2
> total 0
> crw-rw----+ 1 root video 212, 12 Jun  5 12:31 demux0
> crw-rw----+ 1 root video 212, 13 Jun  5 12:31 dvr0
> crw-rw----+ 1 root video 212, 15 Jun  5 12:31 frontend0
> crw-rw----+ 1 root video 212, 14 Jun  5 12:31 net0
> 
> From your post you might miss the demux while the front-end is working.
> 

ls -al /dev/dvb/adapter1/
total 0
drwxr-xr-x 2 root root     120 Jun  7 10:08 .
drwxr-xr-x 5 root root     100 Jun  7 10:08 ..
crw-rw---T 1 root video 212, 5 Jun  7 10:08 demux0
crw-rw---T 1 root video 212, 6 Jun  7 10:08 dvr0
crw-rw---T 1 root video 212, 4 Jun  7 10:08 frontend0
crw-rw---T 1 root video 212, 7 Jun  7 10:08 net0

same for adapter2 (adapter0 is an existing usb dvb-t adapter)

I think all the pieces are there, they just aren't connected up internally correctly. If I deliberately put in a wrong i2c address for the tuner (starts of at 0x12 and is reprogrammed to 0x80 in the usb version, which is what I've copied) then I get an error, so it can definitely see the tuner. And if I tune an incorrect frequency I never get lock or anything so I think that much is working. And my original post shows it can see a stream with no errors, and if I put the incorrect code rate in (eg 2_3 instead of 3_4) then it sees lots of errors.

So suppose that the demux is what's wrong, how could I debug that further?

Is there a block diagram somewhere that explains how the various dvb components feed into each other?

Thanks

James
