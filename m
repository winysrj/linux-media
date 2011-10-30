Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40114 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1J3Nwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 09:52:49 -0400
Received: by iaby12 with SMTP id y12so6117548iab.19
        for <linux-media@vger.kernel.org>; Sun, 30 Oct 2011 06:52:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EAB9F41.40208@redhat.com>
References: <4EAB342F.2020008@lockie.ca>
	<201110290221.05015.marek.vasut@gmail.com>
	<4EAB612A.6010003@xenotime.net>
	<4EAB8B5A.5040908@lockie.ca>
	<4EAB919A.6020401@xenotime.net>
	<4EAB9F41.40208@redhat.com>
Date: Sun, 30 Oct 2011 09:52:48 -0400
Message-ID: <CAOcJUbzLrRGa8MvziFd_OLaJEUyzXgjK-w4vL95gykOwz5otHQ@mail.gmail.com>
Subject: Re: femon patch for dB
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, James <bjlockie@lockie.ca>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 29, 2011 at 2:37 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 29-10-2011 07:39, Randy Dunlap escreveu:
>> On 10/28/11 22:12, James wrote:
>>> diff -r d4e8bf5658ce util/femon/femon.c
>>> --- a/util/femon/femon.c    Fri Oct 07 01:26:04 2011 +0530
>>> +++ b/util/femon/femon.c    Fri Oct 28 18:52:12 2011 -0400
>>> @@ -16,6 +16,9 @@
>>>   * You should have received a copy of the GNU General Public License
>>>   * along with this program; if not, write to the Free Software
>>>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>>> + *
>>> + * James Lockie: Oct. 2011
>>> + * modified to add a switch (-2) to show signal/snr in dB
>>>   */
>>>
>>>
>>> @@ -37,11 +40,16 @@
>>>
>>>  #include <libdvbapi/dvbfe.h>
>>>
>>> +/* the s5h1409 delivers both fields in 0.1dB increments, while
>>> + * some demods expect signal to be 0-65535 and SNR to be in 1/256
>>> increments
>>
>> Looks like thunderbird is being too helpful for us here -- by breaking
>> a long line where it shouldn't be broken.  You can see if
>> <kernel source>/Documentation/email-clients.txt helps you any with that.
>
> This is not a kernel patch, but yes, you're right: there's nothing we can't
> apply it to dvb-apps as-is.
>
> Thunderbird only works well if the html editor is disabled and if the max number
> of lines is set to 0. I use it here, but I'm currently sending patches directly
> from git, as it is simpler, if the smtp server is properly configured.
> There is one plugin for it that fixes those stuff on thunerbird (asalted-patches),
> but this doesn't work with newer versions of it (well, fixing it is probably
> a one-line patch like [2] changing the maxVersion).
>
> [1] https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/
> [2] https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/rev/49d587f60371
>
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

please do not apply this patch - as per the patch description (i
haven't seen the patch yet since it wasnt sent inline) this is a
userspace conversion patch based on the output of *one* demodulator
driver.

I will push the work for the ATSC snr conversions to my git repository
and issue a pull request to Mauro by the end of the day.  This issue
is larger than a simple userspace unit conversion.  Please send in the
patch inline anyway, as some users may wish to experiment with it, but
we need to first standardize the kernel unit reporting before we claim
to report in a given unit.

Best regards,
Michael Krufky
