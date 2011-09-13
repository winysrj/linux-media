Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46076 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726Ab1IMU7I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 16:59:08 -0400
Message-ID: <4E6FC41A.5030803@iki.fi>
Date: Tue, 13 Sep 2011 23:59:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David Waring <davidjw@rd.bbc.co.uk>
CC: linux-media@vger.kernel.org
Subject: Re: recursive locking problem
References: <4E68EE98.90201@iki.fi> <4E69EE5E.8080605@rd.bbc.co.uk>
In-Reply-To: <4E69EE5E.8080605@rd.bbc.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2011 01:45 PM, David Waring wrote:
> On 08/09/11 17:34, Antti Palosaari wrote:
>> [snip]
>>
>> Is there any lock can do recursive locking but unlock frees all locks?
>>
>> Like that:
>> gate_open
>> +gate_open
>> +gate_close
>> == lock is free
>>
>> AFAIK mutex can do only simple lock() + unlock(). Semaphore can do
>> recursive locking, like lock() + lock() + unlock() + unlock(). But how I
>> can do lock() + lock() + unlock() == free.
>>
> Antti,
>
> It's a very bad idea to try and use a mutex like that. The number of
> locks and unlocks must be balanced otherwise you risk accessing
> variables without a lock.
>
> Consider:
>
> static struct mutex foo_mutex;
> static int foo=3;
>
> void a() {
>    mutex_lock(&foo_mutex);
>    if (foo<5) foo++;
>    b();
>    foo--; /*<<<  still need lock here */
>    mutex_unlock(&foo_mutex);
> }
>
> void b() {
>    mutex_lock(&foo_mutex);
>    if (foo>6) foo=(foo>>1);
>    mutex_unlock(&foo_mutex);
> }
>
> Note: this assumes mutex_lock will allow the same thread get multiple
> locks as you would like (which it doesn't).
>
> As pointed out in the code, when a() is called, you still need the lock
> for accesses to foo after the call to b() that also requires the lock.
> If we used the locks in the way you propose then foo would be accessed
> without a lock.
>
> To code properly for cases like these I usually use a wrapper functions
> to acquire the lock and call a thread unsafe version (i.e. doesn't use
> locks) of the function that only uses other thread unsafe functions. e.g.
>
> void a() {
>    mutex_lock(&foo_mutex);
>    __a_thr_unsafe();
>    mutex_unlock(&foo_mutex);
> }
>
> void b() {
>    mutex_lock(&foo_mutex);
>    __b_thr_unsafe();
>    mutex_unlock(&foo_mutex);
> }
>
> static void __a_thr_unsafe() {
>    if (foo<5) foo++;
>    __b_thr_unsafe();
>    foo--;
> }
>
> static void __b_thr_unsafe() {
>    if (foo>6) foo=(foo>>1);
> }
>
> This way a call to a() or b() will acquire the lock once for that
> thread, perform all actions and then release the lock. The mutex is
> handled properly.
>
> Can you restructure the code so that you don't need multiple locks?

Thank you for very long and detailed reply with examples :)

I need lock for hardware access. Single I2C-adapter have two I2C-clients 
that have same I2C-address in same bus. There is gate (demod I2C-gate) 
logic that is used to select desired tuner. See that:
http://palosaari.fi/linux/v4l-dvb/controlling_tuner_af9015_dual_demod.txt

You can never know surely how tuner drivers calls to open or close gate, 
very commonly there is situations where multiple close or open happens. 
That's why lock/unlock is problematic.

.i2c_gate_ctrl() is demod driver callback (struct dvb_frontend_ops) 
which controls gate that gate. That callback is always called from tuner 
driver when gate is needed to open or close.

regards
Antti

-- 
http://palosaari.fi/
