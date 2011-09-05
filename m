Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44230 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1IETJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 15:09:30 -0400
Received: by yxj19 with SMTP id 19so2515884yxj.19
        for <linux-media@vger.kernel.org>; Mon, 05 Sep 2011 12:09:30 -0700 (PDT)
Message-ID: <4E652C9C.9000706@gmail.com>
Date: Mon, 05 Sep 2011 16:10:04 -0400
From: Mauricio Henriquez <buhochileno@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: spca1528 device (Device 015: ID 04fc:1528 Sunplus Technology)..libv4l2:
 error turning on	stream: Timer expired issue
References: <4E63D3F2.8090500@gmail.com>	<20110905091959.727346d5@tele>	<4E64EBDD.9050807@gmail.com> <20110905191517.6945c15c@tele>
In-Reply-To: <20110905191517.6945c15c@tele>
Content-Type: multipart/mixed;
 boundary="------------030000070107040209000800"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030000070107040209000800
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/05/2011 01:15 PM, Jean-Francois Moine wrote:
> On Mon, 05 Sep 2011 11:33:49 -0400
> Mauricio Henriquez<buhochileno@gmail.com>  wrote:
>
>    
>> Thanks Jean, yeap I apply the patch, but still the same kind of messages
>> about timeout sing xawtv or svv:
>>      
> OK Mauricio. So, I need more information. May you set the gspca debug
> level to 0x0f
>
> 	echo 0x0f>  /sys/module/gspca_main/parameters/debug
>
> run 'svv' and send me the kernel messages starting from the last gspca
> open?
>    
Ok, I set the gspca debug thing and this is the dmesg messages after 
running svv:

gspca-2.13.6: [svv] open
gspca-2.13.6: try fmt cap JPEG 640x480
gspca-2.13.6: try fmt cap JPEG 640x480
gspca-2.13.6: frame alloc frsz: 115790
gspca-2.13.6: reqbufs st:0 c:4
gspca-2.13.6: mmap start:b7739000 size:118784
gspca-2.13.6: mmap start:b7621000 size:118784
gspca-2.13.6: mmap start:b7604000 size:118784
gspca-2.13.6: mmap start:b75e7000 size:118784
gspca-2.13.6: init transfer alt 3
gspca-2.13.6: isoc 128 pkts size 512 = bsize:65536
spca1528-2.13.6: wait_status_0 timeout
gspca-2.13.6: kill transfer
gspca-2.13.6: [svv] close
gspca-2.13.6: frame free
gspca-2.13.6: close done
gspca-2.13.6: [svv] open
gspca-2.13.6: try fmt cap JPEG 640x480
gspca-2.13.6: try fmt cap JPEG 640x480
gspca-2.13.6: frame alloc frsz: 115790
gspca-2.13.6: reqbufs st:0 c:4
gspca-2.13.6: mmap start:b7732000 size:118784
gspca-2.13.6: mmap start:b761a000 size:118784
gspca-2.13.6: mmap start:b75fd000 size:118784
gspca-2.13.6: mmap start:b75e0000 size:118784
gspca-2.13.6: init transfer alt 3
gspca-2.13.6: isoc 128 pkts size 512 = bsize:65536
spca1528-2.13.6: wait_status_0 timeout
gspca-2.13.6: kill transfer
gspca-2.13.6: [svv] close
gspca-2.13.6: frame free
gspca-2.13.6: close done

...hope you know what it mean :-) ..let me know if I can help in 
anything else, here I'm also playing with the code :-)

Mauricio
> Thanks.
>
>    


-- 
Mauricio R. Henriquez Schott
Escuela de Ingeniería en Computación
Universidad Austral de Chile - Sede Puerto Montt
Los Pinos S/N, Balneario de Pelluco, Puerto Montt - Chile
Tel: 65-487440
Fax: 65-277156
mail: mauriciohenriquez@uach.cl


--------------030000070107040209000800
Content-Type: text/x-vcard; charset=utf-8;
 name="buhochileno.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="buhochileno.vcf"

YmVnaW46dmNhcmQNCmZuOk1hdXJpY2lvIEhlbnJpcXVleg0KbjpIZW5yaXF1ZXo7TWF1cmlj
aW8NCm9yZztxdW90ZWQtcHJpbnRhYmxlOlVuaXZlcnNpZGFkIEF1c3RyYWwgZGUgQ2hpbGUg
LSBTZWRlIFB1ZXJ0byBNb250dDtFc2N1ZWxhIGRlIENvbXB1dGFjaT1DMz1CM24NCmFkcjo7
O0xvcyBQaW5vcyBTL04gQmFsbmVhcmlvIGRlIFBlbGx1Y287UHVlcnRvIE1vbnR0O0xsYW5x
dWlodWU7NTQ4MDAwMDtDaGlsZQ0KZW1haWw7aW50ZXJuZXQ6bWF1cmljaW9oZW5yaXF1ZXpA
dWFjaC5jbA0KdGl0bGU6RG9jZW50ZQ0KdGVsO3dvcms6NjUtNDg3NDQwDQp0ZWw7ZmF4OjY1
LTI3NzE1Ng0KdXJsOmh0dHA6Ly93d3cubW9ub2JvdGljcy5pYy51YWNoLmNsDQp2ZXJzaW9u
OjIuMQ0KZW5kOnZjYXJkDQoNCg==
--------------030000070107040209000800--
