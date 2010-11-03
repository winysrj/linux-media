Return-path: <mchehab@gaivota>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44184 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab0KCG66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 02:58:58 -0400
MIME-Version: 1.0
In-Reply-To: <20101102012135.GB2648@ucw.cz>
References: <201009161632.59210.arnd@arndb.de>
	<201010192140.47433.oliver@neukum.org>
	<20101019202912.GA30133@kroah.com>
	<201010192244.41913.arnd@arndb.de>
	<20101102012135.GB2648@ucw.cz>
Date: Wed, 3 Nov 2010 08:58:56 +0200
Message-ID: <AANLkTim=suDPVCW+dPCxtasbUj=X8EMgGRHAiGO37cGo@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
From: Pekka Enberg <penberg@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
	Oliver Neukum <oliver@neukum.org>, Valdis.Kletnieks@vt.edu,
	Dave Airlie <airlied@gmail.com>,
	codalist@telemann.coda.cs.cmu.edu,
	ksummit-2010-discuss@lists.linux-foundation.org,
	autofs@linux.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>,
	Samuel Ortiz <samuel@sortiz.org>, Jan Kara <jack@suse.cz>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	netdev@vger.kernel.org, Anders Larsen <al@alarsen.net>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Bryan Schumaker <bjschuma@netapp.com>,
	Christoph Hellwig <hch@infradead.org>,
	Petr Vandrovec <vandrove@vc.cvut.cz>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	linux-fsdevel@vger.kernel.org,
	Evgeniy Dushistov <dushistov@mail.ru>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Hendry <andrew.hendry@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, Nov 2, 2010 at 3:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> @@ -79,6 +79,10 @@ static struct drm_driver driver = {
>>
>>  static int __init i810_init(void)
>>  {
>> +     if (num_present_cpus() > 1) {
>> +             pr_err("drm/i810 does not support SMP\n");
>> +             return -EINVAL;
>> +     }
>>       driver.num_ioctls = i810_max_ioctl;
>>       return drm_init(&driver);
>
> Umm, and now someone onlines second cpu?

Well, I see it's being fixed in a different way but yeah,
num_possible_cpus() would be more appropriate here.
