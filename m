Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:60498 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3GMC7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jul 2013 22:59:25 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so9082707pdj.36
        for <linux-media@vger.kernel.org>; Fri, 12 Jul 2013 19:59:25 -0700 (PDT)
Received: from [192.168.1.108] ([180.218.153.154])
        by mx.google.com with ESMTPSA id om2sm48143913pbb.34.2013.07.12.19.59.23
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 12 Jul 2013 19:59:24 -0700 (PDT)
Message-ID: <51E0C286.9020609@gmail.com>
Date: Sat, 13 Jul 2013 10:59:18 +0800
From: Huei-Horng Yo <hiroshiyui@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH][dvb-apps] Fix 'scan' utility region 0x14 encoding from
 BIG5 to UTF-16BE
References: <CAJNvB=z5YLBUuNy8-ozUDEFxrHwfr7jt=Cp3QOvqZn15DY8qqg@mail.gmail.com>
In-Reply-To: <CAJNvB=z5YLBUuNy8-ozUDEFxrHwfr7jt=Cp3QOvqZn15DY8qqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

於 西元2013年07月13日 10:44, Huei-Horng Yo 提到:
> From: Huei-Horng Yo <hiroshiyui@gmail.com>
>
>
> Signed-off-by: Huei-Horng Yo <hiroshiyui@gmail.com>
> ---
>

Sorry, don't know how to keep tab in GMail and the attachment is encoded 
in MIME form. :(
---
From: Huei-Horng Yo <hiroshiyui@gmail.com>


Signed-off-by: Huei-Horng Yo <hiroshiyui@gmail.com>
---
diff --git a/util/scan/scan.c b/util/scan/scan.c
index 71a20db..98093ee 100644
--- a/util/scan/scan.c
+++ b/util/scan/scan.c
@@ -850,7 +850,7 @@ static void descriptorcpy(char **dest, const 
unsigned char *src, size_t len)
  		case 0x11:	type = "ISO-10646";		break;
  		case 0x12:	type = "ISO-2022-KR";		break;
  		case 0x13:	type = "GB2312";		break;
-		case 0x14:	type = "BIG5";			break;
+		case 0x14:	type = "UTF-16BE";			break;
  		case 0x15:	type = "ISO-10646/UTF-8";	break;
  		case 0x10: /* ISO8859 */
  			if ((*(src + 1) != 0) || *(src + 2) > 0x0f)

