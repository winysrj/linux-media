Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:34715 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdEIN0i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 09:26:38 -0400
Received: by mail-yb0-f174.google.com with SMTP id 8so119265ybw.1
        for <linux-media@vger.kernel.org>; Tue, 09 May 2017 06:26:37 -0700 (PDT)
Received: from mail-yw0-f176.google.com (mail-yw0-f176.google.com. [209.85.161.176])
        by smtp.gmail.com with ESMTPSA id v19sm6402ywg.46.2017.05.09.06.26.35
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 May 2017 06:26:36 -0700 (PDT)
Received: by mail-yw0-f176.google.com with SMTP id l14so221671ywk.1
        for <linux-media@vger.kernel.org>; Tue, 09 May 2017 06:26:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DCirVDd1sXvbZ8j5UDoFw6FSCpbfsJ2RCW7_Swipke3w@mail.gmail.com>
References: <1494156804-9784-1-git-send-email-rajmohan.mani@intel.com>
 <20170508205503.GL7456@valkosipuli.retiisi.org.uk> <CAAFQd5CVrrP5tK_LvDbvDT7F5ZjfO+u26T2ca4pOpPjggB6vxw@mail.gmail.com>
 <20170509104045.GO7456@valkosipuli.retiisi.org.uk> <CAAFQd5DfOhMVFdR35DNTnt_R3pHP4xpdL8BBN+KGc_3S9DO=DA@mail.gmail.com>
 <20170509121610.GQ7456@valkosipuli.retiisi.org.uk> <CAAFQd5DCirVDd1sXvbZ8j5UDoFw6FSCpbfsJ2RCW7_Swipke3w@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 9 May 2017 21:26:14 +0800
Message-ID: <CAAFQd5AissiTA6=TUT3twCWHPEN9gJQq48JHg+3vzuE5qHTbeQ@mail.gmail.com>
Subject: Re: [PATCH] dw9714: Initial driver for dw9714 VCM
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 9, 2017 at 9:22 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> +Rafael, Kevin and Ulf,
>
> On Tue, May 9, 2017 at 8:16 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> Hi Tomasz,
>>
>> On Tue, May 09, 2017 at 07:38:26PM +0800, Tomasz Figa wrote:
>>> On Tue, May 9, 2017 at 6:40 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>> > Hi Tomasz,
>>> >
>>> > On Tue, May 09, 2017 at 04:30:40PM +0800, Tomasz Figa wrote:
>>> >> Hi Sakari,
>>> >>
>>> >> On Tue, May 9, 2017 at 4:55 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>> >> > Hi Rajmohan,
>>> >> >
>>> >> > A few comments below...
>>> >> >
>>> >> > On Sun, May 07, 2017 at 04:33:24AM -0700, rajmohan.mani@intel.com wrote:
>>> >> >> +#ifdef CONFIG_PM
>>> >> >> +
>>> >> >> +static int dw9714_runtime_suspend(struct device *dev)
>>> >> >> +{
>>> >> >> +     return 0;
>>> >> >> +}
>>> >> >> +
>>> >> >> +static int dw9714_runtime_resume(struct device *dev)
>>> >> >> +{
>>> >> >> +     return 0;
>>> >> >
>>> >> > I think it'd be fine to remove empty callbacks.
>>> >>
>>> >> It's actually a bit more complicated (if a PM domain is attached, the
>>> >> callbacks must be present), however in case of external I2C devices it
>>> >> should be fine indeed. However, AFAIK, pm_runtime_no_callbacks()
>>> >> should be called.
>>> >
>>> > I wonder if I'm missing something --- acpi_subsys_runtime_resume() first
>>> > calls acpi_dev_runtime_resume() and if all goes well, the proceeds to call
>>> > pm_generic_runtime_resume() which calls device's runtime_resume() if it's
>>> > non-NULL.
>>> >
>>> > In other words, having a runtime_resume() and runtime_suspend() callbacks
>>> > that return zero is equivalent of having neither of the callbacks.
>>>
>>> Ah, I missed the fact this device is instantiated by ACPI and it has
>>> different handling of runtime PM, which apparently means it doesn't
>>> use the code paths affected by the PM domain thing I mentioned.
>>
>> I have to admit I'm no expert in the topic but I'd presume that other
>> implementations should still maintain consistent behaviour towards drivers.
>> acpi_subsys_runtime_resume() is the PM domain runtime_resume() callback in
>> acpi_general_pm_domain.
>
> Let's see. For platform bus this seems to be reasonable indeed -
> __rpm_get_callback() will use the callbacks of PM domain, device type,
> device class or device bus, whichever is available first, in this
> order. Looking at platform_bus_type, the equivalent resume callback is
> pm_generic_runtime_resume() and it will indeed silently return 0 if
> there is no dev->pm->runtime_resume.
>
> However for I2C bus, i2c_bus_type doesn't seem to have .pm defined.
> Type and class are device/driver-specific things, so let's assume they
> don't have .pm set. If the driver doesn't have .pm, then the only way
> __rpm_get_callback() can return a non-NULL value is when
> dev->pm_domain is non NULL (which seems to be the ACPI case actually).
> Otherwise, if __rpm_get_callback() returns NULL, pm_runtime_get*()
> will fail with -ENOSYS. This is because rpm_resume() calls
> rpm_callback(callback, dev), where callback is the value returned by
> __rpm_get_callback() and rpm_callback() returns -ENOSYS if callback is
> NULL. This is where pm_runtime_no_callbacks() comes handy, as it
> bypasses the code getting and calling the callback, so it doesn't
> return the error anymore.
>
> There is however the other side of the coin. If
> pm_runtime_no_callbacks() is called, all kind of callbacks are
> bypassed, so even the PM domain code is not invoked. This is kind of
> tricky, because the driver must be now aware of whether it's running
> under a PM domain or not and call this pm_runtime_no_callbacks()
> depending on the outcome, to guarantee correct operation (PM domain
> callbacks must be called, even if device driver doesn't have its
> own)... Which IMHO doesn't make sense.
>
> I guess the correct way to proceed here would be adding .pm ops to
> i2c_bus_type, just as it's done with platform_bus_type.

Ah, sorry, I mean, the correct way to proceed here to make the
behavior consistent. For Raj's patch, since a) the driver needs to
restore the control value and b) it's supposed to be primarily
instantiated by ACPI, we shouldn't hit the above problem for now.

Best regards,
Tomasz
