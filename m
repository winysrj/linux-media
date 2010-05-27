Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:53711 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932339Ab0E0Pqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 11:46:45 -0400
Message-ID: <4BFE937B.7000200@arcor.de>
Date: Thu, 27 May 2010 17:44:59 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Bee Hock Goh <beehock@gmail.com>
Subject: Re: [PATCH 3/4] tm6000: bugfix video image
References: <AANLkTinXZL1jy8HF73WeWwCRjDIryevcag1yZUji5iy7@mail.gmail.com>
In-Reply-To: <AANLkTinXZL1jy8HF73WeWwCRjDIryevcag1yZUji5iy7@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050104080704040901000807"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050104080704040901000807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 27.05.2010 16:43, schrieb Luis Henrique Fagundes:
> Hi Stefan,
>
> Looks like your patch sent on May 19th doesn't compile. I might be
> missing something, but I needed the attached patch to make it compile.
>
> Luis
>   

@@ -452,7 +452,7 @@
 	while (len>0) {
 		cpysize=min(len,buf->vb.size-pos);
 		//printk("Copying %d bytes (max=%lu) from %p to %p[%u]\n",cpysize,(*buf)->vb.size,ptr,out_p,pos);
-		memcpy(&out_p[pos], ptr, cpysize);
+		memcpy(&outp[pos], ptr, cpysize);
 		pos+=cpysize;
 		ptr+=cpysize;
 		len-=cpysize;
@@ -464,8 +464,8 @@
 			get_next_buf (dma_q, &buf);
 			if (!buf)
 				break;
-			out_p = videobuf_to_vmalloc(&(buf->vb));
-			if (!out_p)
+			outp = videobuf_to_vmalloc(&(buf->vb));
+			if (!outp)
 				return rc;
 			pos = 0;
 		}


I have overseen that, as I generate a patch. In my devel-tree I have outp.

-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------050104080704040901000807
Content-Type: text/x-vcard; charset=utf-8;
 name="stefan_ringel.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stefan_ringel.vcf"

begin:vcard
fn:Stefan Ringel
n:Ringel;Stefan
email;internet:stefan.ringel@arcor.de
note:web: www.stefanringel.de
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------050104080704040901000807--
