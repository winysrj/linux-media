Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:53498 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751122AbdKMJeu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 04:34:50 -0500
Received: by mail-lf0-f65.google.com with SMTP id 73so3190881lfu.10
        for <linux-media@vger.kernel.org>; Mon, 13 Nov 2017 01:34:49 -0800 (PST)
Subject: Re: [PATCH 2/2] sdlcam: ignore binary
To: Pavel Machek <pavel@ucw.cz>
References: <20171113091908.23531-1-funman@videolan.org>
 <20171113091908.23531-2-funman@videolan.org> <20171113092012.GB20206@amd>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: =?UTF-8?B?UmFmYcOrbCBDYXJyw6k=?= <funman@videolan.org>
Message-ID: <cd304cfa-b45b-a509-8287-cc88bf86465c@videolan.org>
Date: Mon, 13 Nov 2017 10:34:46 +0100
MIME-Version: 1.0
In-Reply-To: <20171113092012.GB20206@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding linux-media, thanks

On 13/11/2017 10:20, Pavel Machek wrote:
> On Mon 2017-11-13 10:19:08, Rafaël Carré wrote:
>> Signed-off-by: Rafaël Carré <funman@videolan.org>
> 
> Acked-by: Pavel	 Machek <pavel@ucw.cz>
> 
>> ---
>>  contrib/test/.gitignore | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/contrib/test/.gitignore b/contrib/test/.gitignore
>> index ad64325b..5bd81d01 100644
>> --- a/contrib/test/.gitignore
>> +++ b/contrib/test/.gitignore
>> @@ -8,3 +8,4 @@ stress-buffer
>>  v4l2gl
>>  v4l2grab
>>  mc_nextgen_test
>> +sdlcam
> 
