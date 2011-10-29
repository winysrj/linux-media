Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:41029 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752401Ab1J2Fj4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Oct 2011 01:39:56 -0400
Message-ID: <4EAB919A.6020401@xenotime.net>
Date: Fri, 28 Oct 2011 22:39:38 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: femon patch for dB
References: <4EAB342F.2020008@lockie.ca> <201110290221.05015.marek.vasut@gmail.com> <4EAB612A.6010003@xenotime.net> <4EAB8B5A.5040908@lockie.ca>
In-Reply-To: <4EAB8B5A.5040908@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/28/11 22:12, James wrote:
> diff -r d4e8bf5658ce util/femon/femon.c
> --- a/util/femon/femon.c    Fri Oct 07 01:26:04 2011 +0530
> +++ b/util/femon/femon.c    Fri Oct 28 18:52:12 2011 -0400
> @@ -16,6 +16,9 @@
>   * You should have received a copy of the GNU General Public License
>   * along with this program; if not, write to the Free Software
>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + * James Lockie: Oct. 2011
> + * modified to add a switch (-2) to show signal/snr in dB
>   */
>  
>  
> @@ -37,11 +40,16 @@
>  
>  #include <libdvbapi/dvbfe.h>
>  
> +/* the s5h1409 delivers both fields in 0.1dB increments, while
> + * some demods expect signal to be 0-65535 and SNR to be in 1/256
> increments

Looks like thunderbird is being too helpful for us here -- by breaking
a long line where it shouldn't be broken.  You can see if
<kernel source>/Documentation/email-clients.txt helps you any with that.

> +*/
> +
>  #define FE_STATUS_PARAMS
> (DVBFE_INFO_LOCKSTATUS|DVBFE_INFO_SIGNAL_STRENGTH|DVBFE_INFO_BER|DVBFE_INFO_SNR|DVBFE_INFO_UNCORRECTED_BLOCKS)
>  
>  static char *usage_str =
>      "\nusage: femon [options]\n"
> -    "     -H        : human readable output\n"
> +    "     -H        : human readable output: (signal: 0-65335, snr:
> 1/256 increments)\n"
> +    "     -2        : human readable output: (signal and snr in .1 dB
> increments)\n"

same problem as above.

>      "     -A        : Acoustical mode. A sound indicates the signal
> quality.\n"
>      "     -r        : If 'Acoustical mode' is active it tells the
> application\n"
>      "                 is called remotely via ssh. The sound is heard on
> the 'real'\n"
> @@ -62,7 +70,7 @@ static void usage(void)
>  
>  
>  static
> -int check_frontend (struct dvbfe_handle *fe, int human_readable,
> unsigned int count)
> +int check_frontend (struct dvbfe_handle *fe, int human_readable, int
> db_readable, unsigned int count)

and again.

>  {
>      struct dvbfe_info fe_info;
>      unsigned int samples = 0;
> @@ -93,31 +101,32 @@ int check_frontend (struct dvbfe_handle
>              fprintf(stderr, "Problem retrieving frontend information:
> %m\n");
>          }
>  
> +        //  print the status code
> +        printf ("status %c%c%c%c%c | ",
> +            fe_info.signal ? 'S' : ' ',
> +            fe_info.carrier ? 'C' : ' ',
> +            fe_info.viterbi ? 'V' : ' ',
> +            fe_info.sync ? 'Y' : ' ',
> +            fe_info.lock ? 'L' : ' ' );
>  
> +        if (db_readable) {
> +                       printf ("signal %3.0fdB | snr %3.0fdB",
> +                (fe_info.signal_strength * 0.1),
> +                (fe_info.snr * 0.1) );
> +        } else if (human_readable) {
> +                       printf ("signal %3u%% | snr %3u%%",
> +                (fe_info.signal_strength * 100) / 0xffff,
> +                (fe_info.snr * 100) / 0xffff );
> +        } else {
> +            printf ("signal %04x | snr %04x",
> +                fe_info.signal_strength,
> +                fe_info.snr );
> +        }
>  
> -        if (human_readable) {
> -                       printf ("status %c%c%c%c%c | signal %3u%% | snr
> %3u%% | ber %d | unc %d | ",
> -                fe_info.signal ? 'S' : ' ',
> -                fe_info.carrier ? 'C' : ' ',
> -                fe_info.viterbi ? 'V' : ' ',
> -                fe_info.sync ? 'Y' : ' ',
> -                fe_info.lock ? 'L' : ' ',
> -                (fe_info.signal_strength * 100) / 0xffff,
> -                (fe_info.snr * 100) / 0xffff,
> -                fe_info.ber,
> -                fe_info.ucblocks);
> -        } else {
> -            printf ("status %c%c%c%c%c | signal %04x | snr %04x | ber
> %08x | unc %08x | ",
> -                fe_info.signal ? 'S' : ' ',
> -                fe_info.carrier ? 'C' : ' ',
> -                fe_info.viterbi ? 'V' : ' ',
> -                fe_info.sync ? 'Y' : ' ',
> -                fe_info.lock ? 'L' : ' ',
> -                fe_info.signal_strength,
> -                fe_info.snr,
> -                fe_info.ber,
> -                fe_info.ucblocks);
> -        }
> +        /* always print ber and ucblocks */
> +        printf (" | ber %08x | unc %08x | ",
> +            fe_info.ber,
> +            fe_info.ucblocks);
>  
>          if (fe_info.lock)
>              printf("FE_HAS_LOCK");
> @@ -145,7 +154,7 @@ int check_frontend (struct dvbfe_handle
>  
>  
>  static
> -int do_mon(unsigned int adapter, unsigned int frontend, int
> human_readable, unsigned int count)
> +int do_mon(unsigned int adapter, unsigned int frontend, int
> human_readable, int db_readable, unsigned int count)

and again.

>  {
>      int result;
>      struct dvbfe_handle *fe;
> @@ -175,7 +184,7 @@ int do_mon(unsigned int adapter, unsigne
>      }
>      printf("FE: %s (%s)\n", fe_info.name, fe_type);
>  
> -    result = check_frontend (fe, human_readable, count);
> +    result = check_frontend (fe, human_readable, db_readable, count);
>  
>      dvbfe_close(fe);
>  
> @@ -186,9 +195,10 @@ int main(int argc, char *argv[])
>  {
>      unsigned int adapter = 0, frontend = 0, count = 0;
>      int human_readable = 0;
> +    int db_readable = 0;
>      int opt;
>  
> -       while ((opt = getopt(argc, argv, "rAHa:f:c:")) != -1) {
> +       while ((opt = getopt(argc, argv, "rAH2a:f:c:")) != -1) {
>          switch (opt)
>          {
>          default:
> @@ -206,6 +216,9 @@ int main(int argc, char *argv[])
>          case 'H':
>              human_readable = 1;
>              break;
> +        case '2':
> +            db_readable = 1;
> +            break;
>          case 'A':
>              // Acoustical mode: we have to reduce the delay between
>              // checks in order to hear nice sound
> @@ -218,7 +231,7 @@ int main(int argc, char *argv[])
>          }
>      }
>  
> -    do_mon(adapter, frontend, human_readable, count);
> +    do_mon(adapter, frontend, human_readable, db_readable, count);
>  
>      return 0;
>  }
> 
> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
