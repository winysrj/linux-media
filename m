Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s23.blu0.hotmail.com ([65.55.111.98]:28224 "EHLO
	blu0-omc2-s23.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbaAJPXw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 10:23:52 -0500
Message-ID: <BLU0-SMTP37B0A51F0A2D2F1E79A730ADB30@phx.gbl>
Date: Fri, 10 Jan 2014 23:23:48 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Andrzej Hajda <a.hajda@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kyungmin.park@samsung.com
Subject: Re: using MFC memory to memery encoder, start stream and queue order
 problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl> <02c701cf07b6$565cd340$031679c0$%debski@samsung.com> <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl> <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com> <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl> <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com> <52CD725E.5060903@hotmail.com> <BLU0-SMTP6650E76A95FA2BB39C6325ADB30@phx.gbl> <52CFD5DF.6050801@samsung.com>
In-Reply-To: <52CFD5DF.6050801@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

于 2014年01月10日 19:13, Andrzej Hajda 写道:
> Hi Randy,
> 
> On 01/10/2014 10:15 AM, randy wrote:
> 
> <snip>
> 
>>> It won't work, if I do that, after step 7, neither OUPUT nor 
>>> CAPTURE will poll return in my program. but ./mfc-encode -m 
>>> /dev/video1 -c h264,header_mode=1 work normally,
>> I am sorry, I didn't well test it, if I use ./mfc-encode -m 
>> /dev/video1 -c h264,header_mode=1 -d 1 then the size of demo.out
>> is zero, but ./mfc-encode -d 1 -m /dev/video1 -c h264 will out a
>> 158 bytes files. When duration is 2, with header_mode=1, the
>> output file size is 228 bytes.Without it, the size is 228 too. I
>> wonder whether it is the driver's problem, as I see this in
>> dmesg [    0.210000] Failed to declare coherent memory for MFC
>> device (0 bytes at 0x43000000) As the driver is not ready to use
>> in 3.13-rc6 as I reported before, I still use the 3.5 from
>> manufacturer.
> 
> I am the author of mfc-encode application, it was written for the 
> mainline kernel 3.8 and later, it should be mentioned in the
> README.txt - I will update it.
Sadness, I have tested 3.10.26, in this version, neither decoder nor
encoder can be work(can't init according to clock problem).
In 3.8, it doesn't have dts support fully and lack many drivers.
I think I shall wait the the mfc done for 3.13.
> App will not work correctly with earlier kernels, mainly (but not
> only) due to lack of end of stream handling in MFC encoder driver. 
> If you use vendor kernel I suggest to look at the vendor's capture 
> apps/libs to check how it uses MFC driver.
> 
Sadness, they doesn't offer any of them, even not any information
about it.
And I can't compile the openmax from samsung. I will report it later
in sourceforge.
> Regards Andrzej
> 
> 
> 
> 

Thank you
ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJS0BCEAAoJEPb4VsMIzTziYJQH/RFX6oSL6JWb4ah/+SOlXT9m
V+qoPGy2h+KB82+vC7l4UNpYUrDO+U13y8G9IerZp3F3i83qBrpIBNb4jr6M1b/u
nm/g3U8RvJoTJkiL9iFFKNBuXZAtYYXFV1RgMtJJ/iXZavte3jOBIOeCpRZndh80
b+ZmihGVPP9d66f/mMFJreFKUwP4UTOR/TuYgv1i106GRLmD2XAWFWTYBXygUeLE
GCRst2D+t4lpTH8Ttz+ZdzXEINZaCgO5Jf1UvK3+nLXfQbJREH9BWmODDhR6M269
hn2lcU0D1HwGnVzdEN/Gx/8gneixg3oWP2nZVJ61w5WlABYpWKKyNbZqsfwzGXM=
=57or
-----END PGP SIGNATURE-----
