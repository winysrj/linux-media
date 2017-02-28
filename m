Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34637 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdB1ErK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 23:47:10 -0500
Received: by mail-qk0-f174.google.com with SMTP id s186so1898742qkb.1
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2017 20:46:13 -0800 (PST)
Subject: Re: Kaffeine commit b510bff2 won't compile
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <bafdb165-261c-0129-e0dc-29819a55ca43@gmail.com>
 <20170227071122.3a319481@vento.lan>
Cc: linux-media@vger.kernel.org
From: bill murphy <gc2majortom@gmail.com>
Message-ID: <a2c23f62-215a-9066-45bc-0b8eebacc84b@gmail.com>
Date: Mon, 27 Feb 2017 23:46:09 -0500
MIME-Version: 1.0
In-Reply-To: <20170227071122.3a319481@vento.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for looking in to it. All is well now.

On a sidenote, given 700 MHz is used for LTE, and not broadcasting

anymore, would you folks consider removing ch 52 thru 69

in the us-atsc-frequencies if I posted a simple patch to dtv-scan-tables?


Bill

On 02/27/2017 05:11 AM, Mauro Carvalho Chehab wrote:
> Em Sun, 26 Feb 2017 20:57:20 -0500
> bill murphy <gc2majortom@gmail.com> escreveu:
>
>> Hi,
>> Can someone double check me on this?
>>
>> It seems there might be a missing header,
>> in the src directory, preventing the last commit from
>> compiling. The commit prior compiles fine. So not that big a deal, just
>> letting folks know what I ran in to.
>>
>> I don't see this file, 'log.h', anywhere in the src directory. Guessing
>> it wasn't 'added' for tracking?
>>
>> git://anongit.kde.org/kaffeine
>>
>> diff between master and previous commit...just a snippet, as other files
>> are including the same missing header.
>>
>> diff --git a/src/dvb/dvbcam_linux.cpp b/src/dvb/dvbcam_linux.cpp
>> index ceb9dbd..5c9c575 100644
>> --- a/src/dvb/dvbcam_linux.cpp
>> +++ b/src/dvb/dvbcam_linux.cpp
>> @@ -18,11 +18,7 @@
>>     * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
>>     */
>>
>> -#include <KLocalizedString>
>> -#include <QDebug>
>> -#if QT_VERSION < 0x050500
>> -# define qInfo qDebug
>> -#endif
>> +#include "../log.h"
>>
>>    #include <errno.h>
>>    #include <fcntl.h>
>>
>> where compile complains of that missing header...
>>
>> Scanning dependencies of target kaffeine
>> [ 20%] Building CXX object
>> src/CMakeFiles/kaffeine.dir/dvb/dvbcam_linux.cpp.o
>> /home/user/src2/kaffeine/src/dvb/dvbcam_linux.cpp:21:20: fatal error:
>> ../log.h: No such file or directory
>> compilation terminated.
> Thanks for complaining about it! I forgot to add src/log.h on the
> commit.
>
> You should be able to compile it now.
>
> Thanks,
> Mauro
